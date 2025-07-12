module float_multi(
    input clk, rst,
    input [31:0] a, b,
    output reg [31:0] z
);

// Internal signals
reg [0:0] a_sign, b_sign, z_sign;
reg [7:0] a_exponent, b_exponent, z_exponent;
reg [22:0] a_mantissa, b_mantissa, z_mantissa;
reg [45:0] product;
reg [1:0] guard_round_sticky;
reg counter;

// Input processing
always @(posedge clk or posedge rst) begin
    if (rst) begin
        a_sign <= 0;
        a_exponent <= 0;
        a_mantissa <= 0;
        b_sign <= 0;
        b_exponent <= 0;
        b_mantissa <= 0;
    end else if (counter == 0) begin
        a_sign <= a[31];
        a_exponent <= a[30:23];
        a_mantissa <= a[22:0];
        b_sign <= b[31];
        b_exponent <= b[30:23];
        b_mantissa <= b[22:0];
    end
end

// Mantissa multiplication
always @(posedge clk or posedge rst) begin
    if (rst) begin
        product <= 0;
    end else if (counter == 1) begin
        product <= {1'b1, a_mantissa} * {1'b1, b_mantissa};
    end
end

// Exponent calculation
always @(posedge clk or posedge rst) begin
    if (rst) begin
        z_exponent <= 0;
    end else if (counter == 2) begin
        z_exponent <= a_exponent + b_exponent - 8'd127;
    end
end

// Rounding
always @(posedge clk or posedge rst) begin
    if (rst) begin
        z_mantissa <= 0;
        guard_round_sticky <= 0;
    end else if (counter == 3) begin
        guard_round_sticky <= product[46:45];
        if (guard_round_sticky[1]) begin
            z_mantissa <= product[45:23] + 1;
        end else begin
            z_mantissa <= product[45:23];
        end
    end
end

// Result formatting
always @(posedge clk or posedge rst) begin
    if (rst) begin
        z <= 0;
    end else if (counter == 4) begin
        z_sign <= a_sign ^ b_sign;
        z <= {z_sign, z_exponent, z_mantissa};
    end
end

// Counter logic
always @(posedge clk or posedge rst) begin
    if (rst) begin
        counter <= 0;
    end else begin
        counter <= counter + 1;
        if (counter == 4) begin
            counter <= 0;
        end
    end
end

endmodule