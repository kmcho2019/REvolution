module multi_booth_8bit (
    input  wire        clk,
    input  wire        reset,
    input  wire [7:0]  a,      // multiplicand
    input  wire [7:0]  b,      // multiplier
    output reg  [15:0] p,      // product output
    output reg         rdy      // ready signal
);

    // Internal signed registers
    reg signed [15:0] multiplicand;
    reg signed [24:0] combined; // {accumulator[16:0], multiplier_ext[8:0]}
    reg [3:0]         count;

    wire [2:0] booth_bits = combined[2:0];

    reg signed [2:0] booth_factor;
    reg signed [24:0] partial_product;
    wire signed [24:0] multiplicand_25 = { {9{multiplicand[15]}}, multiplicand };

    // Booth encoding logic
    always @(*) begin
        case (booth_bits)
            3'b000, 3'b111: booth_factor =  0;
            3'b001, 3'b010: booth_factor =  1;
            3'b011:         booth_factor =  2;
            3'b100:         booth_factor = -2;
            3'b101, 3'b110: booth_factor = -1;
            default:        booth_factor =  0;
        endcase
    end

    // Compute partial product according to booth_factor
    always @(*) begin
        case (booth_factor)
            3'd 0:  partial_product = 25'sd0;
            3'd 1:  partial_product = multiplicand_25;
            3'd 2:  partial_product = multiplicand_25 <<< 1;
           -3'd 1:  partial_product = -multiplicand_25;
           -3'd 2:  partial_product = -(multiplicand_25 <<< 1);
            default: partial_product = 25'sd0;
        endcase
    end

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            multiplicand <= { {8{a[7]}}, a };          // sign-extend to 16 bits
            // Initialize combined:
            // accumulator = 0 (17 bits), multiplier_ext = b extended by one zero bit
            combined <= {17'd0, {b, 1'b0}};            
            count <= 0;
            rdy <= 0;
            p <= 16'd0;
        end else if (!rdy) begin
            // Add partial product to accumulator
            combined[24:8] <= combined[24:8] + partial_product;

            // Arithmetic right shift combined by 2 bits (signed shift)
            combined <= {combined[24], combined[24:2]};

            count <= count + 1;

            if (count == 4'd7) begin
                // After 8 iterations (processing 16 bits), set output and ready
                p <= combined[24:9]; // upper 16 bits are the product
                rdy <= 1;
            end
        end
    end
endmodule