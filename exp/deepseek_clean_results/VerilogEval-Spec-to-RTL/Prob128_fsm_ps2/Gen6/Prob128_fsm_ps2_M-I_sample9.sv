module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output reg done
);

    reg [1:0] state;  // Binary encoding: 00=waiting, 01=byte1, 10=byte2

    always @(posedge clk) begin
        if (reset) begin
            state <= 2'b00;  // Reset to waiting state
            done <= 1'b0;
        end else begin
            done <= 1'b0;  // Default assignment
            
            case (state)
                2'b00: begin  // Waiting state
                    if (in[3]) begin
                        state <= 2'b01;  // Move to byte1 state
                    end
                end
                2'b01: begin  // Byte1 state
                    state <= 2'b10;  // Move to byte2 state
                end
                2'b10: begin  // Byte2 state
                    done <= 1'b1;    // Signal message complete
                    state <= 2'b00;  // Return to waiting state
                end
            endcase
        end
    end

endmodule