module TopModule(
    input  wire        clk,
    input  wire        reset,
    output reg  [2:0]  ena,
    output reg  [15:0] q
);

    // Function to increment a single BCD digit with carry out
    function automatic [4:0] bcd_increment;
        input [3:0] digit_in;
        begin
            if (digit_in == 4'd9)
                bcd_increment = {1'b1, 4'd0}; // carry=1, digit=0
            else
                bcd_increment = {1'b0, digit_in + 4'd1};
        end
    endfunction

    // Intermediate combinational signals for next digits and carry
    reg [3:0] ones_next, tens_next, hundreds_next, thousands_next;
    reg       carry_ones, carry_tens, carry_hundreds;

    always @* begin
        // Start from current digits
        reg [3:0] ones = q[3:0];
        reg [3:0] tens = q[7:4];
        reg [3:0] hundreds = q[11:8];
        reg [3:0] thousands = q[15:12];

        reg [4:0] ones_inc, tens_inc, hundreds_inc, thousands_inc;

        // Increment ones digit
        ones_inc = bcd_increment(ones);
        ones_next = ones_inc[3:0];
        carry_ones = ones_inc[4];

        // Increment tens if ones overflowed
        if (carry_ones) begin
            tens_inc = bcd_increment(tens);
            tens_next = tens_inc[3:0];
            carry_tens = tens_inc[4];
        end else begin
            tens_next = tens;
            carry_tens = 1'b0;
        end

        // Increment hundreds if tens overflowed
        if (carry_tens) begin
            hundreds_inc = bcd_increment(hundreds);
            hundreds_next = hundreds_inc[3:0];
            carry_hundreds = hundreds_inc[4];
        end else begin
            hundreds_next = hundreds;
            carry_hundreds = 1'b0;
        end

        // Increment thousands if hundreds overflowed
        // No further carry needed beyond thousands digit
        if (carry_hundreds) begin
            thousands_inc = bcd_increment(thousands);
            thousands_next = thousands_inc[3:0];
        end else begin
            thousands_next = thousands;
        end
    end

    // Sequential update on positive clock edge with synchronous reset
    always @(posedge clk) begin
        if (reset) begin
            q <= 16'd0;
            ena <= 3'b000;
        end else begin
            q <= {thousands_next, hundreds_next, tens_next, ones_next};
            // ena bits: ena[0]=carry_ones (tens digit increment enable)
            //           ena[1]=carry_tens (hundreds digit increment enable)
            //           ena[2]=carry_hundreds (thousands digit increment enable)
            ena <= {carry_hundreds, carry_tens, carry_ones};
        end
    end

endmodule