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
    localparam IDLE      = 3'b000;
    localparam DETECTING = 3'b001;
    localparam WAIT      = 3'b010;
    localparam CAPTURE   = 3'b011;
    localparam COUNTING  = 3'b100;
    localparam DONE      = 3'b101;

    reg [2:0] state;
    reg [3:0] shift_reg;
    reg [3:0] delay;
    reg [9:0] cycle_counter;  // Counts 0-999
    reg [3:0] period_counter; // Counts delay downto 0
    reg [1:0] bit_counter;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            shift_reg <= 4'b0;
            delay <= 4'b0;
            cycle_counter <= 0;
            period_counter <= 0;
            bit_counter <= 0;
            counting <= 0;
            done <= 0;
            count <= 4'b0;
        end else begin
            case (state)
                IDLE: begin
                    state <= DETECTING;
                    shift_reg <= 4'b0;
                    bit_counter <= 0;
                    counting <= 0;
                    done <= 0;
                end
                
                DETECTING: begin
                    // Shift in data for pattern detection
                    shift_reg <= {shift_reg[2:0], data};
                    bit_counter <= bit_counter + 1;
                    
                    if (bit_counter == 3) begin
                        if (shift_reg == 4'b1101) begin
                            state <= WAIT;
                        end else begin
                            bit_counter <= 0;
                        end
                    end
                end
                
                WAIT: begin
                    // Wait state before capturing delay
                    state <= CAPTURE;
                    bit_counter <= 0;
                end
                
                CAPTURE: begin
                    // Shift in next 4 bits for delay value
                    shift_reg <= {shift_reg[2:0], data};
                    bit_counter <= bit_counter + 1;
                    
                    if (bit_counter == 3) begin
                        delay <= shift_reg;
                        cycle_counter <= 0;
                        period_counter <= shift_reg;
                        counting <= 1;
                        state <= COUNTING;
                    end
                end
                
                COUNTING: begin
                    if (cycle_counter == 999) begin
                        cycle_counter <= 0;
                        period_counter <= period_counter - 1;
                        count <= period_counter - 1;
                        
                        if (period_counter == 0) begin
                            counting <= 0;
                            done <= 1;
                            state <= DONE;
                        end
                    end else begin
                        cycle_counter <= cycle_counter + 1;
                    end
                end
                
                DONE: begin
                    if (ack) begin
                        state <= IDLE;
                        done <= 0;
                    end
                end
            endcase
        end
    end

endmodule