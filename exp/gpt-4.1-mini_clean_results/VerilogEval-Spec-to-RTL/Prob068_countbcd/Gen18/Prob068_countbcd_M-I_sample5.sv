module TopModule (
    input         clk,
    input         reset,
    output [2:0]  ena,
    output [15:0] q
);

    reg [3:0] ones, tens, hundreds, thousands;

    // Enable signals indicate when the next digit should increment:
    // ena[0] enables tens when ones digit is 9,
    // ena[1] enables hundreds when tens digit is 9 and lower digits roll over,
    // ena[2] enables thousands when hundreds digit is 9 and lower digits roll over.
    assign ena[0] = (ones == 4'd9);
    assign ena[1] = ena[0] && (tens == 4'd9);
    assign ena[2] = ena[1] && (hundreds == 4'd9);

    // Combinational carry and next digit values
    wire ones_carry, tens_carry, hundreds_carry;
    wire [3:0] ones_next, tens_next, hundreds_next, thousands_next;

    // Increment ones digit
    assign {ones_carry, ones_next} = (ones == 4'd9) ? {1'b1, 4'd0} : {1'b0, ones + 4'd1};
    // Increment tens digit if carry from ones
    assign {tens_carry, tens_next} = (tens == 4'd9 && ones_carry) ? {1'b1, 4'd0} :
                                    (ones_carry) ? {1'b0, tens + 4'd1} : {1'b0, tens};
    // Increment hundreds digit if carry from tens
    assign {hundreds_carry, hundreds_next} = (hundreds == 4'd9 && tens_carry) ? {1'b1, 4'd0} :
                                             (tens_carry) ? {1'b0, hundreds + 4'd1} : {1'b0, hundreds};
    // Increment thousands digit if carry from hundreds
    assign thousands_next = (hundreds_carry) ? ((thousands == 4'd9) ? 4'd0 : thousands + 4'd1) : thousands;

    always @(posedge clk) begin
        if (reset) begin
            ones      <= 4'd0;
            tens      <= 4'd0;
            hundreds  <= 4'd0;
            thousands <= 4'd0;
        end else begin
            ones      <= ones_next;
            // Update tens only if enable is active (carry from ones)
            if (ones_carry)
                tens <= tens_next;
            // Update hundreds only if enable is active (carry from tens)
            if (tens_carry)
                hundreds <= hundreds_next;
            // Update thousands only if enable is active (carry from hundreds)
            if (hundreds_carry)
                thousands <= thousands_next;
        end
    end

    assign q = {thousands, hundreds, tens, ones};

endmodule