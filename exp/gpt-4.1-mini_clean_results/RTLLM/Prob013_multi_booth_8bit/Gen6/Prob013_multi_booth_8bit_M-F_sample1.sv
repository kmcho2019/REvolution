module multi_booth_8bit (
    input  wire        clk,
    input  wire        reset,
    input  wire [7:0]  a,    // multiplicand
    input  wire [7:0]  b,    // multiplier
    output reg  [15:0] p,    // product output
    output reg         rdy    // ready signal
);

    reg signed [16:0] acc;              // accumulator: signed 17 bits
    reg signed [15:0] multiplicand;    // sign-extended multiplicand (16 bits)
    reg [8:0]         multiplier_ext;  // extended multiplier + appended zero bit (9 bits)
    reg [2:0]         cycle_cnt;        // 3-bit counter for 4 cycles (0 to 3)

    reg signed [16:0] partial_prod;    // partial product for current cycle
    reg signed [25:0] combined;        // concatenated {acc, multiplier_ext} for shift

    // Booth recode operation decoded from multiplier_ext[2:0]
    // 3-bit window at bits [2:0] of multiplier_ext at each cycle
    reg signed [2:0] booth_bits; // 3 bits window for recoding
    reg signed [1:0] booth_op;   // Booth operation: -2, -1, 0, 1, 2

    always @(*) begin
        booth_bits = multiplier_ext[2:0];

        case (booth_bits)
            3'b000, 3'b111: booth_op = 2'sd0;
            3'b001, 3'b010: booth_op = 2'sd1;
            3'b011:         booth_op = 2'sd2;
            3'b100:         booth_op = -2'sd2;
            3'b101, 3'b110: booth_op = -2'sd1;
            default:        booth_op = 2'sd0;
        endcase
    end

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            multiplicand  <= { {8{a[7]}}, a }; // sign-extend multiplicand to 16 bits
            multiplier_ext <= {b, 1'b0};        // multiplier with appended zero LSB (9 bits)
            acc          <= 0;
            cycle_cnt    <= 0;
            rdy          <= 0;
            p            <= 0;
        end else if (!rdy) begin
            // Compute partial product based on booth_op
            // Multiply multiplicand by 0, ±1, or ±2
            case (booth_op)
                2'sd0:  partial_prod = 17'sd0;
                2'sd1:  partial_prod = {multiplicand[15], multiplicand};          // sign-extend to 17 bits
                2'sd2:  partial_prod = ({multiplicand[15], multiplicand} << 1);   // *2
                -2'sd1: partial_prod = -{multiplicand[15], multiplicand};
                -2'sd2: partial_prod = -({multiplicand[15], multiplicand} << 1);
                default: partial_prod = 17'sd0;
            endcase

            // Add partial product to accumulator
            acc <= acc + partial_prod;

            // Combine acc and multiplier_ext into a 26-bit signed vector for arithmetic shift
            combined = {acc + partial_prod, multiplier_ext};

            // Arithmetic right shift combined by 2 bits
            combined = combined >>> 2;

            // Update acc and multiplier_ext after shift
            acc <= combined[25:9];
            multiplier_ext <= combined[8:0];

            cycle_cnt <= cycle_cnt + 1;

            if (cycle_cnt == 3) begin
                p <= combined[16:1]; // product bits: lower 16 bits after shifts (acc[15:0])
                rdy <= 1;
            end
        end
    end

endmodule