module TopModule(
    input clk,
    input reset,
    output [2:0] ena,
    output [15:0] q
);

// Internal wires to connect digit counters
wire [3:0] ones_digit;
wire [3:0] tens_digit;
wire [3:0] hundreds_digit;
wire [3:0] thousands_digit;

// Instantiate digit counters
digit_counter ones_digit_counter(clk, reset, 1'b0, ones_digit);
digit_counter tens_digit_counter(clk, reset, ones_digit[3], tens_digit);
digit_counter hundreds_digit_counter(clk, reset, tens_digit[3], hundreds_digit);
digit_counter thousands_digit_counter(clk, reset, hundreds_digit[3], thousands_digit);

// Generate 'ena' signal based on carry-out of each digit counter
assign ena[0] = ones_digit[3];
assign ena[1] = tens_digit[3];
assign ena[2] = hundreds_digit[3];

// Concatenate digit counter outputs to form 'q'
assign q = {thousands_digit, hundreds_digit, tens_digit, ones_digit};

// Define the digit_counter module
module digit_counter(
    input clk,
    input reset,
    input carry_in,
    output [3:0] q
);
    reg [3:0] q_reg;

    always @(posedge clk) begin
        if (reset) begin
            q_reg <= 4'b0;
        end else if (carry_in && (q_reg == 9)) begin
            q_reg <= 4'b0;
        end else if (carry_in) begin
            q_reg <= q_reg + 1'b1;
        end
    end

    assign q = q_reg;
endmodule

endmodule