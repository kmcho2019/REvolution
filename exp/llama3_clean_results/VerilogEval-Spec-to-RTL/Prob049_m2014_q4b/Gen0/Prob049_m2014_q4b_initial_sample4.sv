module TopModule(
    input  clk,
    input  ar,
    input  d,
    output q
);

reg q_state;

always @(posedge clk or posedge ar) begin
    if (ar) begin
        q_state <= 1'b0;
    end else if (posedge clk) begin
        q_state <= d;
    end
end

assign q = q_state;

endmodule