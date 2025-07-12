module multi_booth_8bit (
    input  wire        clk,
    input  wire        reset,
    input  wire [7:0]  a,    // multiplicand
    input  wire [7:0]  b,    // multiplier
    output reg  [15:0] p,    // product output
    output reg         rdy    // ready signal
);

    // Registers for the algorithm
    reg signed [16:0] acc;           // 17-bit accumulator for partial sums (signed)
    reg [8:0]         multiplier_ext; // multiplier extended with appended zero bit (9 bits)
    reg signed [15:0] multiplicand;  // 16-bit sign-extended multiplicand

    reg [2:0] cycle_cnt;              // cycle counter (0 to 4 for radix-4)

    // Booth encoding operation output: -2, -1, 0, 1, 2
    reg signed [2:0] booth_op;

    // Temporary partial product register (17 bits signed)
    reg signed [16:0] partial_prod;

    // Extract the three bits from multiplier_ext for Booth recoding
    wire [2:0] booth_bits = multiplier_ext[2:0];

    // Combinational logic for Booth recoding based on multiplier_ext[2:0]
    always @(*) begin
        case (booth_bits)
            3'b000, 3'b111: booth_op = 0;    // 0 times multiplicand
            3'b001, 3'b010: booth_op =  1;   // +1 times multiplicand
            3'b011:         booth_op =  2;   // +2 times multiplicand
            3'b100:         booth_op = -2;   // -2 times multiplicand
            3'b101, 3'b110: booth_op = -1;   // -1 times multiplicand
            default:        booth_op =  0;
        endcase
    end

    // Sequential logic: reset, multiplication process
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // Initialize registers
            multiplicand   <= { {8{a[7]}}, a }; // sign-extend multiplicand to 16 bits
            multiplier_ext <= {b, 1'b0};         // multiplier with appended zero bit
            acc            <= 0;
            cycle_cnt      <= 0;
            rdy            <= 0;
            p              <= 0;
            partial_prod   <= 0;
        end else if (!rdy) begin
            // Calculate partial product according to booth_op
            case (booth_op)
                3'd 0: partial_prod <= 17'sd0;
                3'd 1: partial_prod <= {multiplicand[15], multiplicand};           // sign-extend to 17 bits
                3'd 2: partial_prod <= ({multiplicand[15], multiplicand} << 1);   // *2
                -3'd1: partial_prod <= -{multiplicand[15], multiplicand};
                -3'd2: partial_prod <= -({multiplicand[15], multiplicand} << 1);
                default: partial_prod <= 17'sd0;
            endcase

            // Add partial product to accumulator
            acc <= acc + partial_prod;

            // Prepare concatenated register for arithmetic right shift by 2
            // acc:17 bits, multiplier_ext:9 bits => combined 26 bits
            // Shift right arithmetic by 2 bits
            // Use a temporary signed register for combined
            // Perform shift combinationally and assign after

            // To avoid multiple assignments in one clock cycle, use a temp variable
            // We implement this as two steps, with a small combinational block

            // Combine acc and multiplier_ext
            reg signed [25:0] combined;
            combined = {acc + partial_prod, multiplier_ext};
            combined = combined >>> 2;

            // Split back to acc and multiplier_ext
            acc          <= combined[25:9];
            multiplier_ext <= combined[8:0];

            // Increment cycle count
            cycle_cnt <= cycle_cnt + 1'b1;

            // If done, set output and ready signal
            if (cycle_cnt == 3) begin
                p   <= combined[16:1]; // lower 16 bits (bits [16:1]) as product - aligned properly
                rdy <= 1;
            end
        end
    end
endmodule