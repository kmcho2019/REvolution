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
        end else begin
            case (ena)
                2'b01: 
                    // Rotate right by one: LSB becomes MSB
                    q <= {q[0], q[99:1]};
                2'b10: 
                    // Rotate left by one: MSB becomes LSB
                    q <= {q[98:0], q[99]};
                default:
                    // No rotation: hold current value, avoid unnecessary update
                    q <= q;
            endcase
        end
    end

endmodule