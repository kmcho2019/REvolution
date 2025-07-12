module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

// Counter parameters
parameter START = 4'b0001;  // Starting value (1)
parameter END   = 4'b1010;  // Ending value (10)

// Sequential logic with improved timing
always @(posedge clk) begin
    if (reset) begin
        q <= START;
    end
    else begin
        q <= (q == END) ? START : q + 4'b0001;
    end
end

endmodule