module multi_booth_8bit (
    input clk,
    input reset,
    input [7:0] a,
    input [7:0] b,
    output reg [15:0] p,
    output reg rdy
);
    reg signed [15:0] multiplicand;       // sign-extended multiplicand
    reg signed [16:0] multiplier_ext;     // multiplier extended with extra LSB (Q-1) bit
    reg signed [31:0] product;             // accumulator, wider to hold intermediate results
    reg [4:0] ctr;                        // 5-bit counter from 0 to 16

    wire [1:0] booth_bits;

    assign booth_bits = multiplier_ext[1:0]; // Current bit and previous bit (Q0 and Q-1)

    // Booth decoding function: determines operation based on booth_bits
    // 00 or 11 => no operation
    // 01 => +multiplicand
    // 10 => -multiplicand
    function signed [31:0] booth_op;
        input [1:0] bits;
        begin
            case (bits)
                2'b01: booth_op = { {16{multiplicand[15]}}, multiplicand }; // +multiplicand (extended to 32b)
                2'b10: booth_op = -{ {16{multiplicand[15]}}, multiplicand }; // -multiplicand
                default: booth_op = 32'd0;
            endcase
        end
    endfunction

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // Sign-extend multiplicand and multiplier
            multiplicand <= {{8{a[7]}}, a};
            multiplier_ext <= {b, 1'b0}; // Append Q-1 bit = 0
            product <= 32'd0;
            ctr <= 5'd0;
            rdy <= 1'b0;
            p <= 16'd0;
        end else if (!rdy) begin
            if (ctr < 16) begin
                // Perform Booth operation according to current booth bits
                product <= (product >>> 1) + booth_op(booth_bits);
                multiplier_ext <= multiplier_ext >>> 1; // Arithmetic right shift for signed multiplier_ext
                ctr <= ctr + 1;
            end else begin
                // Multiplication complete
                p <= product[15:0]; // lower 16 bits is the product
                rdy <= 1'b1;
            end
        end
    end
endmodule