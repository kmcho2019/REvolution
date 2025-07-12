module TopModule (
    input           clk,
    input           load,
    input   [1:0]   ena,
    input   [99:0]  data,
    output  reg [99:0] q
);

    // Divide the 100-bit register into two 50-bit segments
    reg [49:0] upper_half; // q[99:50]
    reg [49:0] lower_half; // q[49:0]

    // On load, assign data to q and also to halves
    // On rotate right: rotate the full 100-bit by one bit right
    // On rotate left: rotate the full 100-bit by one bit left

    always @(posedge clk) begin
        if (load) begin
            q <= data;
            upper_half <= data[99:50];
            lower_half <= data[49:0];
        end else begin
            case (ena)
                2'b01: begin // rotate right by 1
                    // Save the rightmost bit (q[0]) which will wrap to MSB q[99]
                    // new upper_half = shift right by 1, MSB = q[0] from q[0]
                    // new lower_half = shift right by 1, MSB = LSB of upper_half before shift
                    q <= {q[0], q[99:1]};
                    // Update halves accordingly:
                    upper_half <= {q[0], upper_half[49:1]};
                    lower_half <= {upper_half[0], lower_half[49:1]};
                end
                2'b10: begin // rotate left by 1
                    // Save the leftmost bit (q[99]) which will wrap to LSB q[0]
                    // new upper_half = shift left by 1, LSB = lower_half[49] before shift
                    // new lower_half = shift left by 1, LSB = q[99] from q[99]
                    q <= {q[98:0], q[99]};
                    upper_half <= {upper_half[48:0], lower_half[49]};
                    lower_half <= {lower_half[48:0], q[99]};
                end
                default: begin
                    q <= q;
                    upper_half <= upper_half;
                    lower_half <= lower_half;
                end
            endcase
        end
    end

endmodule