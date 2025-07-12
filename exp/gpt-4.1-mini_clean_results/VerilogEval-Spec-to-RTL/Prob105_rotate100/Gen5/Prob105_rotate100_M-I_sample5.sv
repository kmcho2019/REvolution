module TopModule (
    input clk,
    input load,
    input [1:0] ena,
    input [99:0] data,
    output reg [99:0] q
);

    always @(posedge clk) begin
        if (load) begin
            // Synchronously load input data
            q <= data;
        end else if (ena == 2'b01) begin
            // Rotate right by one: LSB becomes MSB
            q <= {q[0], q[99:1]};
        end else if (ena == 2'b10) begin
            // Rotate left by one: MSB becomes LSB
            q <= {q[98:0], q[99]};
        end
        // else (ena == 2'b00 or 2'b11): hold current value, no update to reduce switching
    end

endmodule