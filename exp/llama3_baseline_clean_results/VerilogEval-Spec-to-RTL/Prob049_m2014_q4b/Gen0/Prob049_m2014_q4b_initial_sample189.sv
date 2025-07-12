module TopModule(
    input clk,
    input ar,
    input d,
    output q
);
reg q_reg;
assign q = q_reg;

always @(posedge clk or posedge ar) begin
    if(ar) begin
        q_reg <= 0;
    end else if (posedge clk) begin
        q_reg <= d;
    end
end

endmodule