module TopModule (
    input         clk,
    input         load,
    input  [1:0]  ena,
    input  [99:0] data,
    output [99:0] q
);

    reg [49:0] upper_half; // bits [99:50]
    reg [49:0] lower_half; // bits [49:0]

    wire left_rot_bit;     // Bit to wrap for left rotation (MSB)
    wire right_rot_bit;    // Bit to wrap for right rotation (LSB)

    assign left_rot_bit  = upper_half[49]; // reg_data[99]
    assign right_rot_bit = lower_half[0];  // reg_data[0]

    always @(posedge clk) begin
        if (load) begin
            upper_half <= data[99:50];
            lower_half <= data[49:0];
        end else begin
            case (ena)
                2'b10: begin // rotate left by 1
                    // Shift upper_half and lower_half left by one bit, wrapping left_rot_bit to lower_half LSB
                    // upper_half shifts left, the MSB is lost and replaced by lower_half MSB
                    // lower_half shifts left, with left_rot_bit as new LSB
                    upper_half <= {upper_half[48:0], lower_half[49]};
                    lower_half <= {lower_half[48:0], left_rot_bit};
                end
                2'b01: begin // rotate right by 1
                    // Shift upper_half and lower_half right by one bit, wrapping right_rot_bit to upper_half MSB
                    upper_half <= {right_rot_bit, upper_half[49:1]};
                    lower_half <= {lower_half[0], lower_half[49:1]};
                end
                default: begin
                    // Hold current value
                    upper_half <= upper_half;
                    lower_half <= lower_half;
                end
            endcase
        end
    end

    assign q = {upper_half, lower_half};

endmodule