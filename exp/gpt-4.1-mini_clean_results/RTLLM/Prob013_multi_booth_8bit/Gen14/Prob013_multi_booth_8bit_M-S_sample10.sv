module multi_booth_8bit (
    input               clk,
    input               reset,
    input      [7:0]    a,      // multiplicand
    input      [7:0]    b,      // multiplier
    output reg [15:0]   p,      // product output
    output reg          rdy      // ready signal
);

    reg signed [15:0] multiplicand;
    reg signed [16:0] product_ext;  // combined product and multiplier + extra bit for Booth encoding
    reg [3:0]         ctr;

    wire [2:0] booth_bits;
    reg signed [16:0] add_sub_val;

    assign booth_bits = product_ext[2:0]; // bits to determine Booth operation

    // Function to decode Booth bits and determine the add/subtract value
    always @(*) begin
        case (booth_bits)
            3'b000, 3'b111: add_sub_val = 17'sd0;
            3'b001, 3'b010: add_sub_val = multiplicand;
            3'b011:         add_sub_val = multiplicand <<< 1;
            3'b100:         add_sub_val = - (multiplicand <<< 1);
            3'b101, 3'b110: add_sub_val = - multiplicand;
            default:        add_sub_val = 17'sd0;
        endcase
    end

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            multiplicand <= { {8{a[7]}}, a }; // sign-extend multiplicand
            // Initialize product_ext: upper 8 bits = 0, lower 8 bits = multiplier sign-extended + 1 zero bit appended
            product_ext <= {9'd0, {b, 1'b0}}; // 17 bits: product(16 downto 9), multiplier(8 downto 0)
            ctr         <= 4'd0;
            p           <= 16'd0;
            rdy         <= 1'b0;
        end else if (!rdy) begin
            if (ctr < 4'd8) begin
                product_ext <= (product_ext + add_sub_val) >>> 2;
                ctr <= ctr + 1;
            end else begin
                p   <= product_ext[16:1]; // discard the appended Booth bit (LSB)
                rdy <= 1'b1;
            end
        end
    end

endmodule