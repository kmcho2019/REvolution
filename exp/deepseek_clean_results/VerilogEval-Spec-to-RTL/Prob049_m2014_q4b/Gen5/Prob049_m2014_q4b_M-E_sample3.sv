module TopModule (
    input clk,
    input ar,
    input d,
    output reg q
);

reg prev_clk;
wire clk_posedge = ~prev_clk & clk;

always @(*) begin
    if (ar) begin
        q = 1'b0;
    end else if (clk_posedge) begin
        q = d;
    end
end

always @(posedge clk or posedge ar) begin
    prev_clk <= clk;
end

endmodule