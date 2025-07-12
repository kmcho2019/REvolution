module TopModule (
    input clk,
    input in,
    output reg out
);

    always @(posedge clk) begin
        if (in) begin
            out <= ~out;  // Toggle when input is high
        end
        // Else maintain state (implicit)
    end

endmodule