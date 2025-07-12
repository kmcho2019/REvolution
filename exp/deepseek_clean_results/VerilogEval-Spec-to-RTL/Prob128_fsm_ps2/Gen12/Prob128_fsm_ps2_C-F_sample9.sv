module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output reg done
);

    reg [1:0] state; // 00: waiting, 01: byte1, 10: byte2
    
    always @(posedge clk) begin
        if (reset) begin
            state <= 2'b00;
            done <= 1'b0;
        end else begin
            // Default assignments
            done <= 1'b0;
            
            // State transitions
            case (state)
                2'b00: begin
                    if (in[3]) begin
                        state <= 2'b01; // Move to byte1 state
                    end
                end
                2'b01: begin
                    state <= 2'b10; // Move to byte2 state
                end
                2'b10: begin
                    done <= 1'b1;   // Assert done
                    state <= 2'b00; // Return to waiting state
                end
                default: state <= 2'b00; // Safety net
            endcase
        end
    end

endmodule