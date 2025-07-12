module TopModule (
    input clk,
    input a,
    output q
);

reg a_prev;
reg q_reg;

always @(posedge clk) begin
    a_prev <= a;
    if (~a_prev & a) begin  // Detect 0->1 transition
        q_reg <= 1'b1;
    end else begin
        q_reg <= 1'b0;
    end
end

assign q = q_reg;

endmodule