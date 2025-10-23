module TopModule (
    input clk,
    input reset,
    input data,
    input done_counting,
    input ack,
    output reg shift_ena,
    output reg counting,
    output reg done
);

    // One-hot state encoding
    parameter IDLE      = 4'b0001;
    parameter DETECTED  = 4'b0010;
    parameter SHIFTING  = 4'b0100;
    parameter COUNTING  = 4'b1000;
    parameter DONE_ST   = 4'b1001;  // Extra bit for done state
    
    reg [3:0] state;
    reg [3:0] pattern_reg;
    reg [1:0] shift_counter;
    
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            pattern_reg <= 4'b0;
            shift_counter <= 2'b0;
            shift_ena <= 1'b0;
            counting <= 1'b0;
            done <= 1'b0;
        end else begin
            // Update pattern detection shift register
            pattern_reg <= {pattern_reg[2:0], data};
            
            case (1'b1)  // Synopsys parallel_case
                state[0]: begin  // IDLE
                    if (pattern_reg == 4'b1101) begin
                        state <= DETECTED;
                        shift_ena <= 1'b1;
                    end
                end
                
                state[1]: begin  // DETECTED
                    state <= SHIFTING;
                    shift_counter <= 2'b1;
                end
                
                state[2]: begin  // SHIFTING
                    if (shift_counter == 2'b11) begin
                        state <= COUNTING;
                        shift_ena <= 1'b0;
                        counting <= 1'b1;
                    end else begin
                        shift_counter <= shift_counter + 1'b1;
                    end
                end
                
                state[3]: begin  // COUNTING
                    if (done_counting) begin
                        state <= DONE_ST;
                        counting <= 1'b0;
                        done <= 1'b1;
                    end
                end
                
                state[4]: begin  // DONE_ST
                    if (ack) begin
                        state <= IDLE;
                        done <= 1'b0;
                    end
                end
            endcase
        end
    end

endmodule