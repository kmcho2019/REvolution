module div_16bit (
    input  wire [15:0] A,        // Dividend
    input  wire [7:0]  B,        // Divisor
    output reg  [15:0] result,   // Quotient
    output reg  [15:0] odd       // Remainder (lower 8 bits valid)
);

    reg [15:0] a_reg;
    reg [7:0]  b_reg;

    // First combinational always block: latch inputs
    always @(*) begin
        a_reg = A;
        b_reg = B;
    end

    // Second combinational always block: perform division in 8 steps, each producing 2 quotient bits
    always @(*) begin
        integer i;
        reg [7:0] remainder;
        reg [15:0] quotient_tmp;
        reg [9:0] segment;  // 8 bits remainder + 2 bits from dividend

        quotient_tmp = 16'd0;
        remainder = 8'd0;

        for (i = 7; i >= 0; i = i - 1) begin
            // Extract next 2 bits from dividend (a_reg) starting from MSB side
            segment = {remainder, a_reg[2*i + 1], a_reg[2*i]};
            
            // Determine how many times divisor fits into segment (0..3)
            // We'll do trial subtraction to find quotient for 2 bits per iteration
            
            if (segment >= (b_reg << 1) + b_reg) begin
                // segment >= 3 * divisor
                segment = segment - ((b_reg << 1) + b_reg); // segment - 3*B
                quotient_tmp[2*i+1] = 1'b1;
                quotient_tmp[2*i]   = 1'b1;
            end else if (segment >= (b_reg << 1)) begin
                // segment >= 2 * divisor
                segment = segment - (b_reg << 1); // segment - 2*B
                quotient_tmp[2*i+1] = 1'b1;
                quotient_tmp[2*i]   = 1'b0;
            end else if (segment >= b_reg) begin
                // segment >= 1 * divisor
                segment = segment - b_reg; // segment - B
                quotient_tmp[2*i+1] = 1'b0;
                quotient_tmp[2*i]   = 1'b1;
            end else begin
                // segment < divisor
                quotient_tmp[2*i+1] = 1'b0;
                quotient_tmp[2*i]   = 1'b0;
                // segment remains unchanged
            end

            remainder = segment[7:0];
        end

        result = quotient_tmp;
        odd = {8'd0, remainder};
    end

endmodule