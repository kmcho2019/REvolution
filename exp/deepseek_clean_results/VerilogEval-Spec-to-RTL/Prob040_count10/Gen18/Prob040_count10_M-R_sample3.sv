module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

reg [3:0] next_q;

// Combinational next state logic
always @(*) begin
    if (reset) begin
        next_q = 4'b0000;
    end
    else if (q[3] & q[0]) begin  // Check for 9 (1001)
        next_q = 4'b0000;
    end
    else begin
        next_q = q + 1'b1;
    end
end

// Sequential state storage
always @(posedge clk) begin
    q <= next_q;
end

endmodule