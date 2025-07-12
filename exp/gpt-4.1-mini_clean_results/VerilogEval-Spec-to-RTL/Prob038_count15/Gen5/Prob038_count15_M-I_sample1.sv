module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

// Count enable signal tied high for continuous counting; 
// can be modified to gate counting if needed for power savings.
wire count_en = 1'b1;

// Toggle flip-flop style counting with synchronous reset
always @(posedge clk) begin
    if (reset) begin
        q <= 4'b0000;
    end else if (count_en) begin
        // Toggle LSB
        q[0] <= ~q[0];
        // Toggle next bit if previous bit is 1 (toggle ripple)
        q[1] <= q[1] ^ q[0];
        q[2] <= q[2] ^ (q[0] & q[1]);
        q[3] <= q[3] ^ (q[0] & q[1] & q[2]);
    end
end

endmodule