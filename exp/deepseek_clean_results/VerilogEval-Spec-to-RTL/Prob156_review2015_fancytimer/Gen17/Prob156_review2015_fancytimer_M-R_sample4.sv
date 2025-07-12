module TopModule (
    input clk,
    input reset,
    input data,
    output reg [3:0] count,
    output reg counting,
    output reg done,
    input ack
);

    // FSM states
    localparam IDLE     = 2'b00;
    localparam CAPTURE  = 2'b01;
    localparam COUNTING = 2'b10;
    localparam DONE     = 2'b11;

    reg [1:0] current_state, next_state;
    reg [3:0] pattern_reg;
    reg [3:0] delay_val;
    reg [2:0] bit_counter;
    reg [15:0] main_counter;
    reg [9:0] sub_counter;  // Counts 0-999 for each delay chunk
    wire [15:0] total_cycles;

    // Calculate (delay_val + 1) * 1000 using shift-and-add
    assign total_cycles = (delay_val + 1) << 10 - (delay_val + 1) << 4 - (delay_val + 1) << 3;

    // State transition logic
    always @(posedge clk) begin
        if (reset) begin
            current_state <= IDLE;
        end else begin
            current_state <= next_state;
        end
    end

    // Next state logic
    always @(*) begin
        case (current_state)
            IDLE: next_state = (pattern_reg == 4'b1101) ? CAPTURE : IDLE;
            CAPTURE: next_state = (bit_counter == 0) ? COUNTING : CAPTURE;
            COUNTING: next_state = (main_counter == 0 && sub_counter == 0) ? DONE : COUNTING;
            DONE: next_state = ack ? IDLE : DONE;
            default: next_state = IDLE;
        endcase
    end

    // Datapath logic
    always @(posedge clk) begin
        if (reset) begin
            pattern_reg <= 4'b0;
            delay_val <= 4'b0;
            bit_counter <= 3'd4;
            main_counter <= 16'b0;
            sub_counter <= 10'b0;
            counting <= 1'b0;
            done <= 1'b0;
            count <= 4'b0;
        end else begin
            case (current_state)
                IDLE: begin
                    pattern_reg <= {pattern_reg[2:0], data};
                    counting <= 1'b0;
                    done <= 1'b0;
                end

                CAPTURE: begin
                    if (bit_counter > 0) begin
                        delay_val <= {delay_val[2:0], data};
                        bit_counter <= bit_counter - 1;
                    end
                end

                COUNTING: begin
                    counting <= 1'b1;
                    
                    if (sub_counter == 10'd999) begin
                        sub_counter <= 10'b0;
                        main_counter <= main_counter - 1;
                        count <= count - 1;
                    end else begin
                        sub_counter <= sub_counter + 1;
                    end
                    
                    // Initialize counters when entering state
                    if (next_state == COUNTING && current_state != COUNTING) begin
                        main_counter <= delay_val;
                        sub_counter <= 10'b0;
                        count <= delay_val;
                    end
                end

                DONE: begin
                    counting <= 1'b0;
                    done <= 1'b1;
                    
                    if (ack) begin
                        pattern_reg <= 4'b0;
                        bit_counter <= 3'd4;
                    end
                end
            endcase
        end
    end

endmodule