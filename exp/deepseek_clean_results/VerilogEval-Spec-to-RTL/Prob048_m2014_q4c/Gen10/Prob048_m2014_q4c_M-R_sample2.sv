module TopModule (
    input  clk,
    input  d,
    input  r,
    output q
);

reg next_q;

// Combinational logic for next state
always @(*) begin
    if (r) begin
        next_q = 1'b0;
    end
    else begin
        next_q = d;
    end
end

// Clocked register update
reg q_reg = 1'b0;
always @(posedge clk) begin
    q_reg <= next_q;
end

assign q = q_reg;

endmodule