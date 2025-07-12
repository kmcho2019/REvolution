module multi_booth_8bit (
    input             clk,
    input             reset,
    input      [7:0]  a,      // multiplicand
    input      [7:0]  b,      // multiplier
    output reg [15:0] p,      // product output
    output reg        rdy      // ready signal
);

    // Internal registers
    reg signed [15:0] multiplicand;    // sign-extended multiplicand
    reg signed [17:0] product;         // extended product register (17 bits to hold shifts and sign)
    reg [8:0] multiplier_ext;          // multiplier extended with appended zero bit for Booth encoding (8 bits + 1)
    reg [2:0] ctr;                     // 3-bit counter: counts 0..4 (4 cycles)
    reg signed [17:0] m_shift;         // multiplicand shifted left by multiples of 2 bits (multiplied by 1 or 2)

    // Booth encoding bits
    wire [2:0] booth_code;

    assign booth_code = {multiplier_ext[1], multiplier_ext[0], multiplier_ext[-1 + 1'b0]}; // dummy to suppress warning; replaced below

    // We'll extract 3 bits: current bit (multiplier_ext[2*i+1]), next bit (multiplier_ext[2*i]), and previous bit (multiplier_ext[2*i-1])
    // Because multiplier_ext length is 9 bits (b[7:0] plus appended zero bit multiplier_ext[0])
    // For iteration i (0 to 3), bits are multiplier_ext[2*i+1], multiplier_ext[2*i], multiplier_ext[2*i -1]
    // For i=0, previous bit = 0 by definition.

    // So, implement booth_code extraction as a function inside always block.

    // Function to get booth_code for current iteration (i)
    function [2:0] get_booth_code;
        input [8:0] m_ext;
        input [2:0] i; // counter from 0 to 3
        reg bit_minus1;
        begin
            // previous bit: for i=0, previous bit is 0
            if (i == 0)
                bit_minus1 = 1'b0;
            else
                bit_minus1 = m_ext[2*i - 1];

            get_booth_code = {m_ext[2*i + 1], m_ext[2*i], bit_minus1};
        end
    endfunction

    // Handle operations based on booth_code:
    // booth_code | Operation
    // 000 or 111: 0
    // 001 or 010: +1 * multiplicand
    // 011: +2 * multiplicand
    // 100: -2 * multiplicand
    // 101 or 110: -1 * multiplicand

    // Partial product selection function
    function signed [17:0] booth_op;
        input [2:0] code;
        input signed [15:0] M;
        reg signed [17:0] M1x, M2x;
        begin
            M1x = { {2{M[15]}}, M };           // M shifted left by 2 bits (<<2)
            M2x = { M, 2'b00 };                // same as M << 2 but as concatenation, 18-bit width
            case (code)
                3'b000,
                3'b111: booth_op = 18'sd0;
                3'b001,
                3'b010: booth_op = { {2{M[15]}}, M };          // +1 * M (M sign-extended to 18 bits)
                3'b011: booth_op = ({ {2{M[15]}}, M } <<< 1);  // +2 * M = M << 1 shifted to 18 bits
                3'b100: booth_op = -(({ {2{M[15]}}, M } <<< 1)); // -2 * M
                3'b101,
                3'b110: booth_op = -({ {2{M[15]}}, M });        // -1 * M
                default: booth_op = 18'sd0;
            endcase
        end
    endfunction

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            multiplicand   <= { {8{a[7]}}, a };           // sign-extend multiplicand to 16 bits
            multiplier_ext <= {b, 1'b0};                   // append zero bit LSB for Booth
            product       <= 18'sd0;
            ctr           <= 3'd0;
            rdy           <= 1'b0;
            p             <= 16'd0;
        end else begin
            if (ctr < 3'd4) begin
                // Get current booth code for current 2 bits of multiplier
                // Extract 3 bits from multiplier_ext for iteration ctr
                // Using function
                reg [2:0] current_booth_code;
                current_booth_code = get_booth_code(multiplier_ext, ctr);

                // Calculate partial product for this booth code
                reg signed [17:0] pp;
                pp = booth_op(current_booth_code, multiplicand);

                // Accumulate partial product into product register
                product <= (product + pp) >>> 2; // Arithmetic right shift by 2 bits for next iteration

                // Shift multiplier_ext right by 2 bits to align for next group
                multiplier_ext <= multiplier_ext >> 2;

                ctr <= ctr + 1'b1;
                rdy <= 1'b0;
            end else begin
                // Multiplication complete
                rdy <= 1'b1;
                // Output final product (lower 16 bits)
                p <= product[15:0];
            end
        end
    end

endmodule