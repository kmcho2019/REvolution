module multi_booth_8bit(
    input clk,
    input reset,
    input [7:0] a,
    input [7:0] b,
    output reg [15:0] p,
    output reg rdy
);

    // Internal signals width:
    // multiplicand: 17 bits signed (to allow +2x or -2x multiplicand safely)
    // multiplier: 9 bits signed (8 bits plus appended 0 LSB)
    // product register: 18 bits signed (enough to accumulate shifts and sums)
    
    reg signed [16:0] multiplicand;  // sign extended a
    reg signed [8:0] multiplier;     // sign extended b with appended zero
    reg signed [17:0] product;       // accumulator
    reg [2:0] ctr;                   // counts 0..4 cycles (3 bits enough)
    
    // Booth code extraction function (3 bits)
    // We will extract bits multiplier[2*ctr+1 : 2*ctr-1]
    // Since multiplier is 9 bits, safe up to ctr=3 (max bit index 7)
    
    wire [2:0] booth_bits;
    assign booth_bits = multiplier[2*ctr +1 -: 3]; // Select 3 bits starting at 2*ctr+1 downwards
    
    // Booth recoding function: returns signed 17-bit multiplicand multiple
    // Encoded by the 3 bits (booth_bits):
    // 000 -> 0
    // 001 -> +1 * multiplicand
    // 010 -> +1 * multiplicand
    // 011 -> +2 * multiplicand
    // 100 -> -2 * multiplicand
    // 101 -> -1 * multiplicand
    // 110 -> -1 * multiplicand
    // 111 -> 0
    //
    // Implemented as a combinational function.
    
    reg signed [17:0] booth_op; // output of booth recoding
    
    always @(*) begin
        case(booth_bits)
            3'b000,
            3'b111: booth_op = 18'sd0;
            3'b001,
            3'b010: booth_op = {multiplicand[16], multiplicand};   // +1 * multiplicand
            3'b011: booth_op = {multiplicand[16], multiplicand} <<< 1; // +2 * multiplicand
            3'b100: booth_op = -({multiplicand[16], multiplicand} <<< 1); // -2 * multiplicand
            3'b101,
            3'b110: booth_op = -{multiplicand[16], multiplicand};  // -1 * multiplicand
            default: booth_op = 18'sd0;
        endcase
    end

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // On reset, load multiplicand, multiplier, reset product, counter and rdy
            // multiplicand = sign-extend a to 17 bits
            multiplicand <= {{9{a[7]}}, a};  // 9+8=17 bits
            // multiplier = sign-extend b to 8 bits + one appended zero bit for Booth
            multiplier <= {b, 1'b0};
            product <= 18'sd0;
            ctr <= 3'd0;
            rdy <= 1'b0;
            p <= 16'd0;
        end else if (!rdy) begin
            if (ctr < 3'd4) begin
                // Each cycle:
                // Add Booth decoded operand shifted to correct position
                // product shifted right 2 bits (arithmetic shift)
                // product = (product >>> 2) + booth_op
                product <= (product >>> 2) + booth_op;
                ctr <= ctr + 1'b1;
            end else begin
                // After 4 cycles, multiplication complete
                // Assign output product as lower 16 bits (since result fits 16 bits)
                p <= product[15:0];
                rdy <= 1'b1;
            end
        end
    end

endmodule