module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

parameter START = 4'b0001;  // Starting value (1)
parameter END   = 4'b1010;  // Ending value (10)

// Registered comparison for better timing
reg at_end;
wire [3:0] next_q = at_end ? START : {q[2:0] + 1'b1, 1'b0} | {3'b0, q[0]};

always @(posedge clk) begin
    if (reset) begin
        q <= START;
        at_end <= 1'b0;
    end
    else begin
        at_end <= (q == END);
        q <= next_q;
    end
end

endmodule