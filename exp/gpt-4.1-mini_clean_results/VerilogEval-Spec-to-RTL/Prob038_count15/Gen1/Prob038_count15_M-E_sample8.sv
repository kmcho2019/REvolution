module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);
    wire t0, t1, t2, t3;

    // Toggle signals for each bit:
    // LSB toggles every clock cycle when not reset
    assign t0 = 1'b1;                        // q[0] toggles every clk
    assign t1 = q[0];                       // q[1] toggles when q[0] is 1
    assign t2 = q[0] & q[1];                // q[2] toggles when q[0] and q[1] are 1
    assign t3 = q[0] & q[1] & q[2];         // q[3] toggles when lower 3 bits are 1

    always @(posedge clk) begin
        if (reset) begin
            q <= 4'd0;
        end else begin
            q[0] <= t0 ^ q[0];        // toggle q[0]
            q[1] <= t1 ^ q[1];        // toggle q[1] when t1=1
            q[2] <= t2 ^ q[2];        // toggle q[2] when t2=1
            q[3] <= t3 ^ q[3];        // toggle q[3] when t3=1
        end
    end
endmodule