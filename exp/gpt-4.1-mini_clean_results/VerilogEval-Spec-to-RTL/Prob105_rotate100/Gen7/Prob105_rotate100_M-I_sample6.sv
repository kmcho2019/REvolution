module TopModule (
    input clk,
    input load,
    input [1:0] ena,
    input [99:0] data,
    output reg [99:0] q
);

    // Enable rotation only when ena == 2'b01 (right) or 2'b10 (left)
    wire rotate_enable = (ena == 2'b01) || (ena == 2'b10);

    always @(posedge clk) begin
        if (load) begin
            // Synchronously load input data
            q <= data;
        end else if (rotate_enable) begin
            case (ena)
                2'b01: 
                    // Rotate right by one: LSB becomes MSB
                    q <= {q[0], q[99:1]};
                2'b10: 
                    // Rotate left by one: MSB becomes LSB
                    q <= {q[98:0], q[99]};
                default: 
                    // No rotation, should not reach here due to rotate_enable gating
                    q <= q;
            endcase
        end else begin
            // No load and no rotation; hold current value without toggling q
            q <= q;
        end
    end

endmodule