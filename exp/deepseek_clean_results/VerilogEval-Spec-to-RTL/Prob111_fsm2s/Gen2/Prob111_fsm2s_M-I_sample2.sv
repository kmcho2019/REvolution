module TopModule (
    input clk,
    input reset,
    input j,
    input k,
    output reg out  // Combined state and output register
);

    // Define states as local parameters
    localparam OFF = 1'b0;
    localparam ON  = 1'b1;

    // State transition and output logic
    always @(posedge clk) begin
        if (reset) begin
            out <= OFF;  // Reset to OFF state (output = 0)
        end else begin
            case (out)
                OFF: out <= j ? ON : OFF;  // J=1 moves to ON, else stay
                ON:  out <= k ? OFF : ON;  // K=1 moves to OFF, else stay
            endcase
        end
    end

endmodule