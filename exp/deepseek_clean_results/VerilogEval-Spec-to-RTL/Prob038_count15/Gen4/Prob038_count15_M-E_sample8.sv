module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

always @(posedge clk) begin
    if (reset) begin
        q <= 4'b0000;
    end
    else begin
        // Independent next-state computation for each bit
        q[0] <= ~q[0];  // Toggles every cycle
        q[1] <= q[0] ? ~q[1] : q[1];
        q[2] <= (q[1] & q[0]) ? ~q[2] : q[2];
        q[3] <= (q[2] & q[1] & q[0]) ? ~q[3] : q[3];
    end
end

endmodule