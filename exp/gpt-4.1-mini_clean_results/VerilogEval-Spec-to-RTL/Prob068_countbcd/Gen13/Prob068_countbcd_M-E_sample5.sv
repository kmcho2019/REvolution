module TopModule (
    input         clk,
    input         reset,
    output [2:0]  ena,
    output [15:0] q
);

    reg [15:0] count;

    wire [3:0] digit0 = count[3:0];
    wire [3:0] digit1 = count[7:4];
    wire [3:0] digit2 = count[11:8];
    wire [3:0] digit3 = count[15:12];

    // Next count candidate: add 1 to the entire 16-bit register
    wire [16:0] raw_next = {1'b0, count} + 17'd1;

    // Extract raw digits from raw_next (lower 16 bits only)
    wire [3:0] r0 = raw_next[3:0];
    wire [3:0] r1 = raw_next[7:4];
    wire [3:0] r2 = raw_next[11:8];
    wire [3:0] r3 = raw_next[15:12];

    // Apply BCD correction: if digit > 9, add 6
    wire [3:0] c0 = (r0 > 4'd9) ? (r0 + 4'd6) : r0;
    wire [3:0] c1 = (r1 > 4'd9) ? (r1 + 4'd6) : r1;
    wire [3:0] c2 = (r2 > 4'd9) ? (r2 + 4'd6) : r2;
    wire [3:0] c3 = (r3 > 4'd9) ? (r3 + 4'd6) : r3;

    // Calculate carry out from each digit correction
    wire c0_carry = (r0 > 4'd9);
    wire c1_carry = (r1 > 4'd9);
    wire c2_carry = (r2 > 4'd9);

    // Compose next count after correction
    wire [15:0] next_count = {c3, c2, c1, c0};

    // Enable signals: indicate when digits 1, 2, 3 are incremented due to carry
    assign ena[0] = c0_carry;                     // enable tens digit increment
    assign ena[1] = ena[0] & c1_carry;            // enable hundreds digit increment
    assign ena[2] = ena[1] & c2_carry;            // enable thousands digit increment

    always @(posedge clk) begin
        if (reset) begin
            count <= 16'd0;
        end else begin
            count <= next_count;
        end
    end

    assign q = count;

endmodule