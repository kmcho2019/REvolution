module TopModule(
    input  clk,
    input  reset,
    output [2:0] ena,
    output [15:0] q
);

    // Internal wires and variables
    reg [3:0] digit_0;
    reg [3:0] digit_1;
    reg [3:0] digit_2;
    reg [3:0] digit_3;
    wire [3:0] next_digit_0;
    wire [3:0] next_digit_1;
    wire [3:0] next_digit_2;
    wire [3:0] next_digit_3;
    wire ena_1;
    wire ena_2;
    wire ena_3;

    // Sequential logic for each digit
    always @(posedge clk) begin
        if (reset) begin
            // Reset all counters
            digit_0 <= 0;
            digit_1 <= 0;
            digit_2 <= 0;
            digit_3 <= 0;
        end else begin
            // Count and propagate enable signals
            digit_0 <= next_digit_0;
            digit_1 <= next_digit_1;
            digit_2 <= next_digit_2;
            digit_3 <= next_digit_3;
        end
    end

    // Combinational logic for next state
    always @(*) begin
        next_digit_0 = digit_0 + 1;
        next_digit_1 = digit_1;
        next_digit_2 = digit_2;
        next_digit_3 = digit_3;
        ena_1 = (digit_0 == 4'd9);
        ena_2 = ena_1 && (digit_1 == 4'd9);
        ena_3 = ena_2 && (digit_2 == 4'd9);

        if (ena_1) begin
            next_digit_0 = 0;
            next_digit_1 = digit_1 + 1;
        end

        if (ena_2) begin
            next_digit_1 = 0;
            next_digit_2 = digit_2 + 1;
        end

        if (ena_3) begin
            next_digit_2 = 0;
            next_digit_3 = digit_3 + 1;
        end

        if (ena_3 && (digit_3 == 4'd9)) begin
            next_digit_3 = 0;
        end
    end

    // Output assignments
    assign q[3:0] = digit_0;
    assign q[7:4] = digit_1;
    assign q[11:8] = digit_2;
    assign q[15:12] = digit_3;
    assign ena[0] = 1'b0; // Always low, since ones digit is always updated
    assign ena[1] = ena_1;
    assign ena[2] = ena_2;

endmodule