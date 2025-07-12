module TopModule (
    input         clk,
    input         reset,
    output [2:0]  ena,
    output [15:0] q
);

    reg [15:0] bcd_count;

    // Extract digits from register
    wire [3:0] ones     = bcd_count[3:0];
    wire [3:0] tens     = bcd_count[7:4];
    wire [3:0] hundreds = bcd_count[11:8];
    wire [3:0] thousands= bcd_count[15:12];

    // Increment logic done combinationally with carry propagation for BCD digits
    wire [3:0] ones_next;
    wire       carry_ones;
    wire [3:0] tens_next;
    wire       carry_tens;
    wire [3:0] hundreds_next;
    wire       carry_hundreds;
    wire [3:0] thousands_next;

    // Increment ones digit and detect carry (rollover)
    assign {carry_ones, ones_next} = (ones == 4'd9) ? {1'b1, 4'd0} : {1'b0, ones + 4'd1};

    // Increment tens digit if ones digit carried
    assign {carry_tens, tens_next} = (tens == 4'd9 && carry_ones) ? {1'b1, 4'd0} :
                                    (carry_ones) ? {1'b0, tens + 4'd1} :
                                    {1'b0, tens};

    // Increment hundreds digit if tens digit carried
    assign {carry_hundreds, hundreds_next} = (hundreds == 4'd9 && carry_tens) ? {1'b1, 4'd0} :
                                            (carry_tens) ? {1'b0, hundreds + 4'd1} :
                                            {1'b0, hundreds};

    // Increment thousands digit if hundreds digit carried
    assign thousands_next = (carry_hundreds) ? ((thousands == 4'd9) ? 4'd0 : thousands + 4'd1) : thousands;

    // ena signals correspond to increment enables for digits 3:1
    // ena[0] for tens increments when ones digit rolls over (carry_ones)
    // ena[1] for hundreds increments when tens digit increments (carry_tens)
    // ena[2] for thousands increments when hundreds digit increments (carry_hundreds)
    assign ena = {carry_hundreds, carry_tens, carry_ones};

    // Assign output q
    assign q = bcd_count;

    always @(posedge clk) begin
        if (reset) begin
            bcd_count <= 16'd0;
        end else begin
            bcd_count <= {thousands_next, hundreds_next, tens_next, ones_next};
        end
    end

endmodule