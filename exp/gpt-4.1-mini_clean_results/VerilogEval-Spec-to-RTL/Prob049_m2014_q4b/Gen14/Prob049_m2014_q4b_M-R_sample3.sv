module TopModule (
    input  clk,
    input  ar,   // Asynchronous active-high reset
    input  d,
    output reg q
);

always @(posedge clk or posedge ar) begin
    if (ar) begin
        q <= 1'b0;   // async reset active high
    end else begin
        q <= d;      // capture data at clock edge
    end
end

endmodule