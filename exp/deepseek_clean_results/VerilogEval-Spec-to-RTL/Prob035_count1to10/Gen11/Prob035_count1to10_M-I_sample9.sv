module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

parameter START = 4'b0001;  // Starting value (1)
parameter END   = 4'b1010;  // Ending value (10)
parameter INC   = 4'b0001;  // Increment value

always @(posedge clk) begin
    if (reset) begin
        q <= START;
    end
    else begin
        q <= (q == END) ? START : q + INC;
    end
end

endmodule