module TopModule(
    input  clk,
    input  a,
    output q
);

reg q_reg;

always_ff @(posedge clk) begin
    if(a) begin
        q_reg <= ~q_reg; // Toggle the state
    end else begin
        q_reg <= q_reg; // Retain the state
    end
end

assign q = q_reg;

endmodule