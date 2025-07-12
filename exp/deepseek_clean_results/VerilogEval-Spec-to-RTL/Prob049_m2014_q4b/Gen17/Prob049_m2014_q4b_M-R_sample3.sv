module TopModule (
    input clk,
    input ar,
    input d,
    output q
);

reg q_reg;
reg prev_clk;

// Edge detection
wire posedge_clk = clk & ~prev_clk;

always @(*) begin
    if (ar) begin
        q_reg = 1'b0;
    end
    else if (posedge_clk) begin
        q_reg = d;
    end
end

always @(posedge clk or posedge ar) begin
    prev_clk <= clk;
end

assign q = q_reg;

endmodule