module TopModule (
    input clk,
    input load,
    input [1:0] ena,
    input [99:0] data,
    output reg [99:0] q
);

    always @(posedge clk) begin
        // Update q only if loading or rotating (ena = 01 or 10)
        if (load) begin
            q <= data;
        end else if (ena == 2'b01) begin
            // Rotate right by one bit
            q <= {q[0], q[99:1]};
        end else if (ena == 2'b10) begin
            // Rotate left by one bit
            q <= {q[98:0], q[99]};
        end
        // else retain previous q (no assignment to reduce switching)
    end

endmodule