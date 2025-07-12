module div_16bit(
    input [15:0] A,
    input [7:0] B,
    output reg [15:0] result,
    output reg [15:0] odd
);

// Stage 1: Load dividend and divisor into pipeline
reg [15:0] dividend;
reg [7:0] divisor;
assign dividend = A;
assign divisor = B;

// Stage 2-3: Compare higher bits of dividend with divisor and update quotient
wire [15:0] quotient;
wire [7:0] remainder;
assign quotient = (dividend[15:8] >= divisor) ? (1 << 8) : 0;
assign remainder = (dividend[15:8] >= divisor) ? (dividend[15:8] - divisor) : dividend[15:8];

// Stage 4: Concatenate remainder with next bit of dividend
wire [15:0] temp_quotient;
wire [7:0] temp_remainder;
assign temp_quotient = quotient;
assign temp_remainder = remainder;

// Stage 5: Output final quotient and remainder
reg [15:0] final_quotient;
reg [7:0] final_remainder;
always @(*) begin
    final_quotient = 0;
    final_remainder = 0;

    for (int i = 7; i >= 0; i--) begin
        if (temp_remainder >= divisor) begin
            final_quotient = final_quotient | (1 << i);
            temp_remainder = temp_remainder - divisor;
        end
        temp_remainder = {temp_remainder[6:0], dividend[i]};
    end

    result = final_quotient;
    odd = {8'd0, temp_remainder};
end

endmodule