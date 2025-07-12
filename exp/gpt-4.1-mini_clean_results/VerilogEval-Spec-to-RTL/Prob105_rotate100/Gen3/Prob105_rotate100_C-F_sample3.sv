module TopModule (
    input clk,
    input load,
    input [1:0] ena,
    input [99:0] data,
    output reg [99:0] q
);

    always @(posedge clk) begin
        if (load) begin
            // Synchronously load input data into q
            q <= data;
        end else begin
            case (ena)
                2'b01: 
                    // Rotate right by one bit: LSB wraps to MSB
                    q <= {q[0], q[99:1]};
                2'b10: 
                    // Rotate left by one bit: MSB wraps to LSB
                    q <= {q[98:0], q[99]};
                default: 
                    // No rotation: retain q to minimize toggling
                    q <= q;
            endcase
        end
    end

endmodule