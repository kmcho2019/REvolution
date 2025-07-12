module TopModule (
    input clk,
    input reset,
    input data,
    output [3:0] count,
    output counting,
    output done,
    input ack
);

    // FSM states
    localparam IDLE     = 2'b00;
    localparam CAPTURE = 2'b01;
    localparam COUNTING = 2'b10;
    localparam DONE     = 2'b11;

    reg [1:0] state, next_state;
    reg [3:0] pattern_reg;
    reg [3:0] delay_reg;
    reg [3:0] delay_value;
    reg [9:0] cycle_counter;
    reg [1:0] bit_counter;

    // Pattern detection and delay capture
    always @(posedge clk) begin
        if (reset) begin
            pattern_reg <= 4'b0;
            delay_reg <= 4'b0;
            bit_counter <= 0;
        end else begin
            case (state)
                IDLE: begin
                    pattern_reg <= {pattern_reg[2:0], data};
                    if (bit_counter == 3) begin
                        bit_counter <= 0;
                    end else begin
                        bit_counter <= bit_counter + 1;
                    end
                end
                
                CAPTURE: begin
                    delay_reg <= {delay_reg[2:0], data};
                    if (bit_counter == 3) begin
                        bit_counter <= 0;
                    end else begin
                        bit_counter <= bit_counter + 1;
                    end
                end
                
                default: begin
                    // Maintain values in other states
                end
            endcase
        end
    end

    // Delay value and cycle counter
    always @(posedge clk) begin
        if (reset) begin
            delay_value <= 4'b0;
            cycle_counter <= 0;
        end else begin
            case (state)
                CAPTURE: begin
                    if (bit_counter == 3) begin
                        delay_value <= {delay_reg[2:0], data};
                        cycle_counter <= 0;
                    end
                end
                
                COUNTING: begin
                    if (cycle_counter == 999) begin
                        cycle_counter <= 0;
                        if (delay_value != 0)
                            delay_value <= delay_value - 1;
                    end else begin
                        cycle_counter <= cycle_counter + 1;
                    end
                end
                
                default: begin
                    // Maintain values in other states
                end
            endcase
        end
    end

    // State transition
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
        end else begin
            state <= next_state;
        end
    end

    // Next state logic
    always @(*) begin
        case (state)
            IDLE: 
                next_state = (pattern_reg == 4'b1101 && bit_counter == 3) ? CAPTURE : IDLE;
            
            CAPTURE: 
                next_state = (bit_counter == 3) ? COUNTING : CAPTURE;
            
            COUNTING: 
                next_state = (delay_value == 0 && cycle_counter == 999) ? DONE : COUNTING;
            
            DONE: 
                next_state = ack ? IDLE : DONE;
            
            default: 
                next_state = IDLE;
        endcase
    end

    // Output logic
    assign counting = (state == COUNTING);
    assign done = (state == DONE);
    assign count = (state == COUNTING) ? delay_value : 4'b0;

endmodule