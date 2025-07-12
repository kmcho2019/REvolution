module float_multi(
    input clk, rst,
    input [31:0] a, b,
    output reg [31:0] z
);

// Internal signals
reg [2:0] state; // State machine
reg [23:0] a_mantissa, b_mantissa; // Mantissas of inputs
reg [8:0] a_exponent, b_exponent; // Exponents of inputs
reg a_sign, b_sign; // Sign bits of inputs
reg [47:0] product; // Intermediate product of mantissas
reg [23:0] z_mantissa; // Mantissa of result
reg [7:0] z_exponent; // Exponent of result, adjusted for bias
reg z_sign; // Sign bit of result
reg guard_bit, round_bit, sticky; // Rounding control bits

// State machine states
localparam IDLE = 3'b000;
localparam INPUT_PROCESSING = 3'b001;
localparam SPECIAL_CASE_HANDLING = 3'b010;
localparam MANTISSA_MULTIPLICATION = 3'b011;
localparam ROUNDING_NORMALIZATION = 3'b100;
localparam OUTPUT_GENERATION = 3'b101;

// Assignments
assign a_mantissa = a[22:0];
assign a_exponent = a[30:23];
assign a_sign = a[31];
assign b_mantissa = b[22:0];
assign b_exponent = b[30:23];
assign b_sign = b[31];

// State machine logic
always @(posedge clk) begin
    if (rst) begin
        state <= IDLE;
    end else begin
        case (state)
            IDLE: begin
                state <= INPUT_PROCESSING;
            end
            INPUT_PROCESSING: begin
                if (a_exponent == 8'd255 || b_exponent == 8'd255) begin
                    state <= SPECIAL_CASE_HANDLING;
                end else if (a_exponent == 0 && a_mantissa == 0) begin
                    z <= 32'b0; // Result is zero
                    state <= OUTPUT_GENERATION;
                end else if (b_exponent == 0 && b_mantissa == 0) begin
                    z <= 32'b0; // Result is zero
                    state <= OUTPUT_GENERATION;
                end else begin
                    state <= MANTISSA_MULTIPLICATION;
                end
            end
            SPECIAL_CASE_HANDLING: begin
                if (a_exponent == 8'd255 && a_mantissa!= 0) begin // NaN
                    z <= 32'b1; // Result is NaN
                end else if (b_exponent == 8'd255 && b_mantissa!= 0) begin // NaN
                    z <= 32'b1; // Result is NaN
                end else if (a_exponent == 8'd255 && a_mantissa == 0) begin // Infinity
                    z <= (a_sign == 1)? 32'hff800000 : 32'h7f800000; // Result is infinity
                end else if (b_exponent == 8'd255 && b_mantissa == 0) begin // Infinity
                    z <= (b_sign == 1)? 32'hff800000 : 32'h7f800000; // Result is infinity
                end
                state <= OUTPUT_GENERATION;
            end
            MANTISSA_MULTIPLICATION: begin
                product <= {1'b1, a_mantissa} * {1'b1, b_mantissa};
                z_exponent <= a_exponent + b_exponent - 8'd127;
                state <= ROUNDING_NORMALIZATION;
            end
            ROUNDING_NORMALIZATION: begin
                guard_bit <= product[23];
                round_bit <= product[22];
                sticky <= |product[21:0];
                if (round_bit && (guard_bit || sticky)) begin
                    z_mantissa <= product[47:24] + 1;
                end else begin
                    z_mantissa <= product[47:24];
                end
                z_sign <= a_sign ^ b_sign;
                state <= OUTPUT_GENERATION;
            end
            OUTPUT_GENERATION: begin
                z <= {z_sign, z_exponent, z_mantissa};
                state <= IDLE; // Reset state machine
            end
            default: begin
                state <= IDLE;
            end
        endcase
    end
end

endmodule