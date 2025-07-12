module TopModule(
    input clk,
    input reset,
    output reg [2:0] ena,
    output reg [15:0] q
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

    // Registers to hold intermediate increments and carries
    reg [4:0] ones_inc, tens_inc, hundreds_inc, thousands_inc;
    reg carry_ones, carry_tens, carry_hundreds, carry_thousands;
    reg [3:0] ones_next, tens_next, hundreds_next, thousands_next;
    reg [2:0] ena_next;

    always @(posedge clk) begin
        if (reset) begin
            q <= 16'd0;
            ena <= 3'b000;
        end else begin
            // Extract current digits
            ones_next     = q[3:0];
            tens_next     = q[7:4];
            hundreds_next = q[11:8];
            thousands_next= q[15:12];

            // Increment ones digit
            ones_inc = bcd_increment(q[3:0]);
            ones_next = ones_inc[3:0];
            carry_ones = ones_inc[4];

            // Increment tens digit only if ones digit overflowed
            if (carry_ones) begin
                tens_inc = bcd_increment(q[7:4]);
                tens_next = tens_inc[3:0];
                carry_tens = tens_inc[4];
            end else begin
                tens_next = q[7:4];
                carry_tens = 1'b0;
            end

            // Increment hundreds digit only if tens digit overflowed
            if (carry_tens) begin
                hundreds_inc = bcd_increment(q[11:8]);
                hundreds_next = hundreds_inc[3:0];
                carry_hundreds = hundreds_inc[4];
            end else begin
                hundreds_next = q[11:8];
                carry_hundreds = 1'b0;
            end

            // Increment thousands digit only if hundreds digit overflowed
            if (carry_hundreds) begin
                thousands_inc = bcd_increment(q[15:12]);
                thousands_next = thousands_inc[3:0];
                carry_thousands = thousands_inc[4];
            end else begin
                thousands_next = q[15:12];
                carry_thousands = 1'b0;
            end

            // Assemble next q value
            q <= {thousands_next, hundreds_next, tens_next, ones_next};

            // ena bits as specified:
            // ena[0] - tens digit increment enable (carry from ones)
            // ena[1] - hundreds digit increment enable (carry from tens)
            // ena[2] - thousands digit increment enable (carry from hundreds)
            ena_next = {carry_hundreds, carry_tens, carry_ones};
            ena <= ena_next;
        end
    end

endmodule