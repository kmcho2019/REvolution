module TopModule (
    input clk,
    input ar,
    input d,
    output q
);

reg q_ff;

// Clocked behavior: capture D on rising edge
always @(posedge clk) begin
    q_ff <= d;
end

// Async reset override using continuous assignment
assign q = ar ? 1'b0 : q_ff;

endmodule