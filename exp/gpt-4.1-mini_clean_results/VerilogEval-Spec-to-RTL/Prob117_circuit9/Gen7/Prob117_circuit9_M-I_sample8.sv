module TopModule (
    input clk,
    input a,
    output reg [2:0] q
);

reg [2:0] cnt; // internal counter: 0 to 6

// Next count logic (modulo 7 increment)
wire [3:0] sum = cnt + 4; // 4-bit to catch carry
wire [2:0] q_next = (sum >= 7) ? (sum - 7) : sum; // modulo 7 addition

always @(posedge clk) begin
    if (a)
        cnt <= 3'd0;      // reset counter to zero when a=1 (q=4)
    else
        cnt <= (cnt == 3'd6) ? 3'd0 : cnt + 1; // modulo 7 counter increment
end

always @(*) begin
    // q = (cnt + 4) mod 7
    q = q_next;
end

endmodule