module float_multi(
    input clk, rst,
    input [31:0] a, b,
    output reg [31:0] z
);

// Internal signals
reg [2:0] state;
reg sign_a, sign_b, sign_z;
reg [7:0] exp_a, exp_b, exp_z;
reg [22:0] mant_a, mant_b, mant_z;
reg [45:0] product;

// State machine
always @(posedge clk) begin
    if (rst) begin
        state <= 3'b000;
    end else begin
        case (state)
            3'b000: begin // Input processing
                sign_a <= a[31];
                exp_a <= a[30:23];
                mant_a <= a[22:0];
                sign_b <= b[31];
                exp_b <= b[30:23];
                mant_b <= b[22:0];
                state <= 3'b001;
            end
            3'b001: begin // Exponent calculation and mantissa multiplication
                exp_z <= exp_a + exp_b - 8'd127;
                product <= {1'b1, mant_a} * {1'b1, mant_b};
                sign_z <= sign_a ^ sign_b;
                state <= 3'b010;
            end
            3'b010: begin // Normalization and rounding
                if (product[45]) begin // Overflow
                    exp_z <= exp_z + 1;
                    product <= product >> 1;
                end
                if (exp_z < 8'd1) begin // Underflow
                    exp_z <= 8'd0;
                    mant_z <= product[22:0];
                end else begin
                    mant_z <= product[44:23];
                end
                z <= {sign_z, exp_z, mant_z};
                state <= 3'b000;
            end
            default: state <= 3'b000;
        endcase
    end
end

// Special case handling for NaN and infinity
always @(*) begin
    if ((exp_a == 8'd255 && mant_a != 23'd0) || (exp_b == 8'd255 && mant_b != 23'd0)) begin
        z <= 32'd0; // Set output to zero for NaN or infinity
    end else if (exp_a == 8'd255 && mant_a == 23'd0) begin
        z <= {sign_a, 8'd255, 23'd0}; // Set output to infinity
    end else if (exp_b == 8'd255 && mant_b == 23'd0) begin
        z <= {sign_b, 8'd255, 23'd0}; // Set output to infinity
    end
end

endmodule