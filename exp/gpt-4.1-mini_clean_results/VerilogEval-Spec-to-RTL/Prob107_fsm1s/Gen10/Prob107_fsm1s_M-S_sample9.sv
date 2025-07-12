module TopModule(
    input clk,
    input reset,
    input in,
    output reg out
);

    // State and output combined:
    // out=1 means state B, out=0 means state A

    always @(posedge clk) begin
        if (reset)
            out <= 1'b1; // reset to state B
        else begin
            case (out)
                1'b1: out <= (in == 1'b0) ? 1'b0 : 1'b1; // B state transition
                1'b0: out <= (in == 1'b0) ? 1'b1 : 1'b0; // A state transition
            endcase
        end
    end

endmodule