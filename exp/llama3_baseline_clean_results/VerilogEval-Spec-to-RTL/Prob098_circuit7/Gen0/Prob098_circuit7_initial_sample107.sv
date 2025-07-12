module TopModule (
    input  clk,
    input  a,
    output q
);

reg [1:0] count;
reg q_reg;

always @(posedge clk) begin
    if (~a) begin
        count <= count + 1;
        if (count == 2) begin
            q_reg <= 1;
        end
    end else if (a) begin
        count <= 0;
        if (q_reg) begin
            q_reg <= 0;
        end
    end
end

assign q = q_reg;

endmodule