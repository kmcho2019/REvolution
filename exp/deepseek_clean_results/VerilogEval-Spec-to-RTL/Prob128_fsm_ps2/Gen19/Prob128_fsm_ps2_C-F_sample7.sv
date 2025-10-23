module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output reg done
);

    reg [1:0] state;

    always @(posedge clk) begin
        if (reset) begin
            state <= 2'b00;
            done <= 1'b0;
        end else begin
            // Default assignments
            done <= 1'b0;
            
            // State transitions
            case (state)
                2'b00: begin // Idle state
                    if (in[3]) begin
                        state <= 2'b01; // Start new message
                    end
                end
                2'b01: state <= 2'b10; // Second byte
                2'b10: begin // Third byte
                    state <= 2'b00; // Return to idle
                    done <= 1'b1; // Signal completion
                end
                default: state <= 2'b00; // Safety net
            endcase
        end
    end

endmodule