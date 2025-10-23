module TopModule(
    input clk,
    input reset,
    input [7:0] d,
    output logic [7:0] q
);

always_ff @(negedge clk) begin
    if (reset) begin
        // Using bit-wise assignment to reduce switching activity
        q[0] <= 0;
        q[1] <= 0;
        q[2] <= 0;
        q[3] <= 0;
        q[4] <= 1;
        q[5] <= 1;
        q[6] <= 0;
        q[7] <= 0;
    end else begin
        // Using non-blocking assignment for better timing performance
        q <= d;
    end
end

endmodule