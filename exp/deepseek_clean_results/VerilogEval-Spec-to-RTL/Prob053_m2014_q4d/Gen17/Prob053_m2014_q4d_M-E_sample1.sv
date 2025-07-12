module TopModule (
    input clk,
    input in,
    output reg out
);

    // T flip-flop implementation
    always @(posedge clk) begin
        if (in) begin
            out <= ~out;  // Toggle when in=1
        end
        // else retain value (implicit)
    end

endmodule