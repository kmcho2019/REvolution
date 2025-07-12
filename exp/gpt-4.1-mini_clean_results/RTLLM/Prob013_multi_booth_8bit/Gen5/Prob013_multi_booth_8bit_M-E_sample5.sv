module multi_booth_8bit (
    input  wire        clk,
    input  wire        reset,
    input  wire [7:0]  a,    // multiplicand
    input  wire [7:0]  b,    // multiplier
    output reg  [15:0] p,    // product output
    output reg         rdy    // ready signal
);

    reg signed [16:0] acc;      // accumulator: signed 17 bits to hold intermediate sum
    reg signed [15:0] multiplicand; // sign-extended multiplicand
    reg [8:0]         multiplier_ext; // extended multiplier with appended zero bit (8 bits + 1 zero)
    reg [2:0]         cycle_cnt;

    wire [2:0] booth_bits;
    reg signed [1:0] booth_op; // -2, -1, 0, 1, 2 for Booth recode

    // Extract current 3 bits for Booth encoding from multiplier_ext
    assign booth_bits = multiplier_ext[1:0] | (multiplier_ext[2] << 2); // concatenate multiplier_ext[2:0]

    always @(*) begin
        // Booth recoding based on multiplier_ext[2:0]:
        // 000,111 = 0
        // 001,010 = +1
        // 011     = +2
        // 100     = -2
        // 101,110 = -1
        case (multiplier_ext[2:0])
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
            // Generate partial product based on booth_op
            // Multiply multiplicand by 0, ±1, or ±2
            // Left shift multiplicand by 0 or 1 for *2 multiplication
            reg signed [16:0] partial_prod;
            case (booth_op)
                2'sd0:  partial_prod = 0;
                2'sd1:  partial_prod = {multiplicand[15], multiplicand};          // sign-extend to 17 bits
                2'sd2:  partial_prod = {multiplicand[15], multiplicand} << 1;    // *2
                -2'sd1: partial_prod = -{multiplicand[15], multiplicand};
                -2'sd2: partial_prod = -(({multiplicand[15], multiplicand} << 1));
                default: partial_prod = 0;
            endcase

            // Add partial product to accumulator
            acc <= acc + partial_prod;

            // Arithmetic right shift combined {acc, multiplier_ext} by 2 bits
            // Concatenate acc (17 bits) and multiplier_ext (9 bits) into 26 bits
            reg signed [25:0] combined;
            combined = {acc, multiplier_ext};
            combined = combined >>> 2;

            // Split back acc and multiplier_ext
            acc <= combined[25:9];
            multiplier_ext <= combined[8:0];

            cycle_cnt <= cycle_cnt + 1;

            if (cycle_cnt == 3) begin
                p <= acc[15:0]; // lower 16 bits is the product
                rdy <= 1;
            end
        end
    end

endmodule