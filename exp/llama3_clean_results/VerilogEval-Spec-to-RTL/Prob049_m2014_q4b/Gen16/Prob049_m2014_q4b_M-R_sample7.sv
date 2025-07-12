module TopModule(
    input clk,
    input ar,
    input d,
    output reg q
);

initial q = 1'b0;

always @(posedge clk or posedge ar) begin
    if (ar) begin
        q <= #0 1'b0; // Immediate reset
    end else if (posedge clk) begin
        q <= #0 d; // Assign d on positive edge of clk
    end
end

endmodule