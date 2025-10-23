module TopModule(
    input  clk,
    input  a,
    output q
);

reg [1:0] counter;
reg q_reg;
assign q = q_reg;

always @(posedge clk) begin
    if (a == 0) begin
        counter <= 0;
        q_reg <= 1;
    end else begin
        counter <= counter + 1;
        if (counter == 1) begin
            q_reg <= 0;
        end else begin
            q_reg <= q_reg;
        end
    end
end

endmodule