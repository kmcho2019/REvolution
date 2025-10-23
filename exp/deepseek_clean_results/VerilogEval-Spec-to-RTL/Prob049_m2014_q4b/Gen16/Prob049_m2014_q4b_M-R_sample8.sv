module TopModule (
    input clk,
    input ar,
    input d,
    output q
);

reg q_reg;

// Asynchronous reset has priority
// On reset, clear the register
// Otherwise, on clock edge, sample the input
assign q = q_reg;

always @* begin
    if (ar) begin
        q_reg = 1'b0;
    end
    else if (clk && $rose(clk)) begin
        q_reg = d;
    end
end

endmodule