module TopModule (
    input clk,
    input reset,
    input slowena,
    output reg [3:0] q
);

always @(posedge clk) begin
    if (reset)
        q <= 4'd0;
    else begin
        q <= (q + slowena > 4'd9) ? 4'd0 : q + slowena;
    end
end

endmodule