module TopModule (
    input  clk,
    input  [7:0] in,
    output reg parity
);

reg [7:0] in_reg;

// Register input to detect changes and reduce switching on parity output
always @(posedge clk) begin
    if (in != in_reg) begin
        in_reg <= in;
        parity <= ^in; // Update parity only when input changes
    end
end

endmodule