module TopModule (
    input clk,
    input a,
    output reg [2:0] q
);

initial q = 3'd4;

always @(posedge clk) begin
    if (a) begin
        q <= 3'd4;
    end else begin
        // q cycles through values 4,5,6,0,1,... modulo 7
        // increment q modulo 7
        q <= (q == 3'd6) ? 3'd0 : q + 3'd1;
    end
end

endmodule