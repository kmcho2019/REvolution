module TopModule (
    input clk,
    input ar,
    input d,
    output q
);

reg q_reg;
wire q_next;

// Synchronous behavior
always @(posedge clk) begin
    q_reg <= d;
end

// Asynchronous reset combined with synchronous behavior
assign q_next = ar ? 1'b0 : q_reg;
assign q = q_next;

endmodule