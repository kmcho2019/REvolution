module TopModule (
    input clk,
    input reset,
    output reg [31:0] q
);

always @(posedge clk) begin
    if (reset) begin
        q <= 32'h1;
    end
    else begin
        // Compute feedback bit
        feedback = q[0];
        // Shift right
        q <= q >> 1;
        // Apply feedback to tap positions
        if (feedback) begin
            q[31] <= q[31] ^ feedback;
            q[21] <= q[21] ^ feedback;
            q[1]  <= q[1]  ^ feedback;
            q[0]  <= q[0]  ^ feedback;
        end
    end
end

endmodule