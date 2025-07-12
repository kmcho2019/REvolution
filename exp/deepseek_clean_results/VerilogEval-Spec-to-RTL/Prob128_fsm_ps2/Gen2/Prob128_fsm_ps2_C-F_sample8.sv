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
            // Only assert done when transitioning from state 2 to 0
            done <= (state == 2'b10);

            case (state)
                2'b00: begin
                    // Wait for start byte
                    if (in[3]) begin
                        state <= 2'b01;
                    end
                end
                2'b01: begin
                    // First byte received, expect second
                    state <= 2'b10;
                end
                2'b10: begin
                    // Second byte received, expect third
                    state <= 2'b00;
                end
                default: state <= 2'b00;
            endcase
        end
    end

endmodule