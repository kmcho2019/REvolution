module TopModule (
    input           clk,
    input           load,
    input   [1:0]   ena,
    input   [99:0]  data,
    output reg [99:0] q
);

    // Internal register update enable signal: update q only on load or valid rotation
    wire update_en = load || (ena == 2'b01) || (ena == 2'b10);

    always @(posedge clk) begin
        if (load) begin
            // Synchronously load input data with highest priority
            q <= data;
        end else if (ena == 2'b01) begin
            // Rotate right by one bit: LSB wraps around to MSB
            q <= {q[0], q[99:1]};
        end else if (ena == 2'b10) begin
            // Rotate left by one bit: MSB wraps around to LSB
            q <= {q[98:0], q[99]};
        end else begin
            // No load or rotation: retain current value to avoid toggling
            q <= q;
        end
    end

endmodule