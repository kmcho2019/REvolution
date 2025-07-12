module TopModule (
    input clk,
    input load,
    input [1:0] ena,
    input [99:0] data,
    output reg [99:0] q
);
    reg bit_wrap;

    always @(posedge clk) begin
        if (load) begin
            // Load entire data synchronously
            q <= data;
        end else begin
            case (ena)
                2'b01: begin
                    // Rotate right by one bit
                    bit_wrap = q[0];           // Save LSB
                    q <= {bit_wrap, q[99:1]}; // Shift right, insert saved LSB to MSB
                end
                2'b10: begin
                    // Rotate left by one bit
                    bit_wrap = q[99];          // Save MSB
                    q <= {q[98:0], bit_wrap};  // Shift left, insert saved MSB to LSB
                end
                default: begin
                    // No rotation, keep q unchanged
                    q <= q;
                end
            endcase
        end
    end
endmodule