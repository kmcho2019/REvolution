module TopModule (
    input         clk,
    input         reset,
    output [2:0]  ena,
    output [15:0] q
);

    reg [15:0] bcd_reg;
    reg [15:0] bcd_next;

    // Internal carry signals for digits
    reg c1, c2, c3;

    // Extract digits for convenience
    wire [3:0] d0 = bcd_reg[3:0];    // ones
    wire [3:0] d1 = bcd_reg[7:4];    // tens
    wire [3:0] d2 = bcd_reg[11:8];   // hundreds
    wire [3:0] d3 = bcd_reg[15:12];  // thousands

    // Combinational logic for next BCD value and carry propagation
    always @* begin
        integer i;
        reg [3:0] digits [3:0];
        reg carry;
        
        // Initialize digits from current register
        digits[0] = d0;
        digits[1] = d1;
        digits[2] = d2;
        digits[3] = d3;
        
        carry = 1'b1;  // Start with increment carry for ones digit
        
        // Propagate increment and carry through each digit
        for (i = 0; i < 4; i = i + 1) begin
            if (carry) begin
                if (digits[i] == 4'd9) begin
                    digits[i] = 4'd0;
                    carry = 1'b1;
                end else begin
                    digits[i] = digits[i] + 4'd1;
                    carry = 1'b0;
                end
            end
        end
        
        // Assign carry flags for ena output
        c1 = (d0 == 4'd9);                    // carry from ones digit
        c2 = c1 & (d1 == 4'd9);              // carry from tens digit after ones
        c3 = c2 & (d2 == 4'd9);              // carry from hundreds digit after tens and ones

        // Compose next BCD value
        bcd_next = {digits[3], digits[2], digits[1], digits[0]};
    end

    // Sequential logic: update BCD register synchronously
    always @(posedge clk) begin
        if (reset) begin
            bcd_reg <= 16'd0;
        end else begin
            bcd_reg <= bcd_next;
        end
    end

    assign q = bcd_reg;
    assign ena = {c3, c2, c1};

endmodule