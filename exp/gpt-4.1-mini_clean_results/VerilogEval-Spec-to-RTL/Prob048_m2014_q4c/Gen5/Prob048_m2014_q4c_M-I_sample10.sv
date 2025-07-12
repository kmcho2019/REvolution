module TopModule (
    input clk,
    input d,
    input r,
    output reg q
);

// Create an enable signal that is high when reset is active or data input changes
wire enable = r | (d != q);

// Generate gated clock by ANDing clk with enable
wire gated_clk = clk & enable;

always @(posedge gated_clk) begin
    if (r)
        q <= 1'b0;
    else
        q <= d;
end

endmodule