module TopModule (
    input clk,
    input d,
    output q
);

reg q_reg;

always @(posedge clk or negedge clk) begin
    if (clk) begin
        // Posedge
        q_reg <= d;
    end else begin
        // Negedge
        q_reg <= d;
    end
end

assign q = q_reg;

endmodule