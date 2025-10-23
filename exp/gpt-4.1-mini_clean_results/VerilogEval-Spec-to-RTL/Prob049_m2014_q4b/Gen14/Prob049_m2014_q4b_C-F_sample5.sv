module TopModule (
    input  clk,
    input  ar,   // Asynchronous active-high reset
    input  d,
    output q
);

reg q_reg;

// Positive-edge triggered D flip-flop with asynchronous active-high reset
always @(posedge clk or posedge ar) begin
    if (ar) begin
        q_reg <= 1'b0;
    end else begin
        q_reg <= d;
    end
end

assign q = q_reg;

endmodule