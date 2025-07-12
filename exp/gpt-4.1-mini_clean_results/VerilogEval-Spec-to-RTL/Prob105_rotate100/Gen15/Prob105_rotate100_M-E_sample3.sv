module TopModule (
    input clk,
    input load,
    input [1:0] ena,
    input [99:0] data,
    output reg [99:0] q
);

    reg [49:0] upper; // bits [99:50]
    reg [49:0] lower; // bits [49:0]

    always @(posedge clk) begin
        if (load) begin
            upper <= data[99:50];
            lower <= data[49:0];
        end else begin
            case (ena)
                2'b10: begin // rotate left by 1
                    // Capture bits needed for rotation
                    // left rotate by 1 bit: q <= {q[98:0], q[99]};
                    // So upper shifts left by 1, LSB gets MSB of lower
                    // lower shifts left by 1, LSB gets MSB of upper (wrap around)
                    reg upper_msb;
                    reg lower_msb;
                    upper_msb = upper[49];
                    lower_msb = lower[49];
                    upper <= {upper[48:0], lower_msb};
                    lower <= {lower[48:0], upper_msb};
                end
                2'b01: begin // rotate right by 1
                    // right rotate by 1 bit: q <= {q[0], q[99:1]};
                    // So lower shifts right by 1, MSB gets LSB of upper
                    // upper shifts right by 1, MSB gets LSB of lower (wrap around)
                    reg upper_lsb;
                    reg lower_lsb;
                    upper_lsb = upper[0];
                    lower_lsb = lower[0];
                    upper <= {lower_lsb, upper[49:1]};
                    lower <= {upper_lsb, lower[49:1]};
                end
                default: begin
                    // no rotation, hold current values
                    upper <= upper;
                    lower <= lower;
                end
            endcase
        end
        q <= {upper, lower};
    end

endmodule