module TopModule (
    input clk,
    input load,
    input [1:0] ena,
    input [99:0] data,
    output reg [99:0] q
);

    reg [99:0] q_next;

    always @* begin
        // Default: no rotation, hold current value
        q_next = q;

        if (ena == 2'b01) begin
            // Rotate right by one bit
            q_next = {q[0], q[99:1]};
        end else if (ena == 2'b10) begin
            // Rotate left by one bit
            q_next = {q[98:0], q[99]};
        end
        // For ena == 2'b00 or 2'b11, q_next remains q (no rotate)
    end

    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            q <= q_next;
        end
    end

endmodule