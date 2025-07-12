module TopModule(
    input  clk,
    input  reset,
    output [2:0] ena,
    output [15:0] q
);

// internal registers for each digit
reg [3:0] ones_count;
reg [3:0] tens_count;
reg [3:0] hundreds_count;
reg [3:0] thousands_count;

// internal signals for carry and next state
wire ones_carry;
wire tens_carry;
wire hundreds_carry;

// assign outputs
assign q = {thousands_count, hundreds_count, tens_count, ones_count};
assign ena = {hundreds_carry, tens_carry, ones_carry};

// compute next state and carry signals
assign ones_carry = (ones_count == 4'd9) && (1'b1);
assign tens_carry = (tens_count == 4'd9) && ones_carry;
assign hundreds_carry = (hundreds_count == 4'd9) && tens_carry;

// update state registers
always @(posedge clk) begin
    if (reset) begin
        ones_count <= 4'd0;
        tens_count <= 4'd0;
        hundreds_count <= 4'd0;
        thousands_count <= 4'd0;
    end else begin
        if (ones_carry) begin
            ones_count <= 4'd0;
            if (tens_carry) begin
                tens_count <= 4'd0;
                if (hundreds_carry) begin
                    hundreds_count <= 4'd0;
                    if (1'b1) begin
                        thousands_count <= thousands_count + 1;
                    end else begin
                        thousands_count <= thousands_count;
                    end
                end else begin
                    hundreds_count <= hundreds_count + 1;
                    thousands_count <= thousands_count;
                end
            end else begin
                tens_count <= tens_count + 1;
                hundreds_count <= hundreds_count;
                thousands_count <= thousands_count;
            end
        end else begin
            ones_count <= ones_count + 1;
            tens_count <= tens_count;
            hundreds_count <= hundreds_count;
            thousands_count <= thousands_count;
        end
    end
end

endmodule