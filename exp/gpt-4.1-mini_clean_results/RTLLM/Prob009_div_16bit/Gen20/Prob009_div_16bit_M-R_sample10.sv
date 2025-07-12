module div_16bit (
    input  wire [15:0] A,       // Dividend
    input  wire [7:0]  B,       // Divisor
    output reg  [15:0] result,  // Quotient
    output reg  [15:0] odd      // Remainder (lower 8 bits valid)
);

    reg [15:0] a_reg;
    reg [7:0]  b_reg;

    // Latch inputs combinationally as per specification
    always @(*) begin
        a_reg = A;
        b_reg = B;
    end

    // Internal wires for remainder stages and quotient bits
    wire [8:0] rem_stages [0:16];
    wire [15:0] quotient_wire;

    // Initial remainder stage is zero
    assign rem_stages[0] = 9'd0;

    genvar i;
    generate
        for (i = 0; i < 16; i = i + 1) begin : DIV_LOOP
            wire [8:0] shifted;
            wire [8:0] subtracted;
            wire       cmp;

            // Shift previous remainder left by 1 and bring down next dividend bit
            assign shifted = {rem_stages[i][7:0], a_reg[15 - i]};
            // Subtract divisor extended to 9 bits
            assign subtracted = shifted - {1'b0, b_reg};
            // Compare remainder and divisor for subtraction feasibility
            assign cmp = (shifted >= {1'b0, b_reg});
            // Update next remainder stage based on comparison
            assign rem_stages[i+1] = cmp ? subtracted : shifted;
            // Set quotient bit accordingly (MSB first)
            assign quotient_wire[15 - i] = cmp;
        end
    endgenerate

    // Assign outputs combinationally
    always @(*) begin
        result = quotient_wire;
        odd = {8'd0, rem_stages[16][7:0]};
    end

endmodule