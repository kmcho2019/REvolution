module TopModule (
    input         clk,
    input         reset,
    output [2:0]  ena,    // ena[2]: thousands, ena[1]: hundreds, ena[0]: tens increments
    output [15:0] q
);

    reg [3:0] d0, d1, d2, d3; // ones, tens, hundreds, thousands digits

    // Increment ones digit and detect carry out
    wire ones_carry = (d0 == 4'd9);
    wire [3:0] d0_next = ones_carry ? 4'd0 : (d0 + 1'b1);

    // Increment tens digit on ones_carry
    wire tens_carry = ones_carry && (d1 == 4'd9);
    wire [3:0] d1_next = ones_carry ? (tens_carry ? 4'd0 : d1 + 1'b1) : d1;

    // Increment hundreds digit on tens_carry
    wire hundreds_carry = tens_carry && (d2 == 4'd9);
    wire [3:0] d2_next = tens_carry ? (hundreds_carry ? 4'd0 : d2 + 1'b1) : d2;

    // Increment thousands digit on hundreds_carry
    wire thousands_carry = hundreds_carry && (d3 == 4'd9);
    wire [3:0] d3_next = hundreds_carry ? (thousands_carry ? 4'd0 : d3 + 1'b1) : d3;

    // Enable signals indicate increment for tens, hundreds, thousands digits
    assign ena = {hundreds_carry, tens_carry, ones_carry};

    always @(posedge clk) begin
        if (reset) begin
            d0 <= 4'd0;
            d1 <= 4'd0;
            d2 <= 4'd0;
            d3 <= 4'd0;
        end else begin
            d0 <= d0_next;
            d1 <= d1_next;
            d2 <= d2_next;
            d3 <= d3_next;
        end
    end

    assign q = {d3, d2, d1, d0};

endmodule