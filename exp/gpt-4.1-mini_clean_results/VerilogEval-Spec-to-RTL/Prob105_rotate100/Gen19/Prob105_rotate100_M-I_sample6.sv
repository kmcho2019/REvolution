module TopModule (
    input clk,
    input load,
    input [1:0] ena,
    input [99:0] data,
    output reg [99:0] q
);

    reg [99:0] next_q;

    always @(*) begin
        if (load) begin
            next_q = data;
        end else if (ena == 2'b10) begin
            // Rotate left by one bit: MSB wraps to LSB
            next_q = {q[98:0], q[99]};
        end else if (ena == 2'b01) begin
            // Rotate right by one bit: LSB wraps to MSB
            next_q = {q[0], q[99:1]};
        end else begin
            // Hold current value
            next_q = q;
        end
    end

    always @(posedge clk) begin
        // Only update q when load or rotation enabled to avoid unnecessary toggling
        if (load || (ena == 2'b10) || (ena == 2'b01))
            q <= next_q;
    end

endmodule