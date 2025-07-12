module multi_booth_8bit (
    input              clk,
    input              reset,
    input      [7:0]   a,       // multiplicand
    input      [7:0]   b,       // multiplier
    output reg [15:0]  p,       // product
    output reg         rdy       // ready signal
);

    reg signed [15:0] multiplicand;
    reg signed [16:0] multiplier_ext;   // multiplier with appended zero bit
    reg signed [31:0] product;           // accumulator for partial products
    reg [3:0]         ctr;

    reg signed [16:0] m1;    // multiplicand extended for partial products (+1 * multiplicand)
    reg signed [17:0] m2;    // +2 * multiplicand

    reg [2:0] booth_bits;
    reg signed [31:0] partial;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            multiplicand   <= {{8{a[7]}}, a};       // sign-extend multiplicand
            multiplier_ext <= {b, 1'b0};            // multiplier extended with zero bit LSB
            product        <= 32'sd0;
            ctr            <= 4'd0;
            rdy            <= 1'b0;
            p              <= 16'd0;

            m1 <= {{1{a[7]}}, a};                   // sign-extend multiplicand to 17 bits (+1*multiplicand)
            m2 <= ({{1{a[7]}}, a} <<< 1);           // +2 * multiplicand
        end else if (!rdy) begin
            if (ctr < 4'd8) begin
                booth_bits = multiplier_ext[(2*ctr)+1 -: 3]; // 3 bits for Booth encoding

                case (booth_bits)
                    3'b000,
                    3'b111: partial = 32'sd0;
                    3'b001,
                    3'b010: partial = { {15{m1[16]}}, m1 };      // +1 * multiplicand
                    3'b011: partial = { {14{m2[17]}}, m2 };      // +2 * multiplicand
                    3'b100: partial = -({ {14{m2[17]}}, m2 });   // -2 * multiplicand
                    3'b101,
                    3'b110: partial = -({ {15{m1[16]}}, m1 });   // -1 * multiplicand
                    default: partial = 32'sd0;
                endcase

                product <= product + (partial <<< (2*ctr));
                ctr <= ctr + 1;
            end else begin
                p <= product[15:0];
                rdy <= 1'b1;
            end
        end
    end

endmodule