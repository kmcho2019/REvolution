module multi_booth_8bit (
    input               clk,
    input               reset,
    input      [7:0]    a,       // multiplicand
    input      [7:0]    b,       // multiplier
    output reg [15:0]   p,       // product
    output reg          rdy       // ready signal
);

    // State machine states
    localparam IDLE = 1'b0,
               BUSY = 1'b1;

    reg state;
    reg [1:0] cycle_cnt; // 4 cycles for radix-4 (2 bits per cycle for 8 bits)
    
    // Registers for multiplicand, multiplier, and product accumulator
    reg signed [15:0] multiplicand;           // sign-extended multiplicand
    reg [9:0] extended_multiplier;            // multiplier plus 2 zero bits for Booth encoding
    reg signed [33:0] product;                 // accumulator (34 bits)

    // Extract 3 Booth bits corresponding to current cycle (2*cycle_cnt to 2*cycle_cnt+2)
    wire [2:0] booth_bits = extended_multiplier[2*cycle_cnt +: 3];

    // Booth factor decoding: map 3 bits to multiplier factor (-2, -1, 0, 1, 2)
    reg signed [2:0] booth_factor;
    always @(*) begin
        case (booth_bits)
            3'b000, 3'b111: booth_factor =  3'sd0;
            3'b001, 3'b010: booth_factor =  3'sd1;
            3'b011:         booth_factor =  3'sd2;
            3'b100:         booth_factor = -3'sd2;
            3'b101, 3'b110: booth_factor = -3'sd1;
            default:        booth_factor =  3'sd0;
        endcase
    end

    // Generate partial product: multiplicand * booth_factor, sign extended to 17 bits
    wire signed [16:0] multiplicand_ext = {multiplicand[15], multiplicand}; // 17 bits
    reg signed [16:0] partial_product;
    always @(*) begin
        case (booth_factor)
            3'sd0:  partial_product = 17'sd0;
            3'sd1:  partial_product = multiplicand_ext;
            3'sd2:  partial_product = multiplicand_ext <<< 1; // multiply by 2
           -3'sd1:  partial_product = -multiplicand_ext;
           -3'sd2:  partial_product = -(multiplicand_ext <<< 1);
            default: partial_product = 17'sd0;
        endcase
    end

    // Main state machine and datapath sequential logic
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state              <= IDLE;
            multiplicand       <= {{8{a[7]}}, a};       // sign-extend multiplicand
            extended_multiplier<= {b, 2'b00};            // append two zeros for Booth encoding
            product            <= 34'sd0;
            cycle_cnt          <= 2'd0;
            p                  <= 16'd0;
            rdy                <= 1'b0;
        end else begin
            case (state)
                IDLE: begin
                    rdy <= 1'b0;
                    product <= 34'sd0;
                    cycle_cnt <= 2'd0;
                    // Start multiplication immediately after reset in this simple design
                    state <= BUSY;
                end

                BUSY: begin
                    // Add partial product to product shifted right by 2 bits
                    // product = (product >>> 2) + (partial_product aligned to LSB)
                    // Shift product right by 2 bits arithmetic shift before adding partial product
                    product <= (product >>> 2) + {{17{partial_product[16]}}, partial_product};

                    if (cycle_cnt == 2'd3) begin
                        // Done after 4 cycles
                        p   <= product[15:0]; // final 16-bit product output
                        rdy <= 1'b1;
                        state <= IDLE;
                    end else begin
                        cycle_cnt <= cycle_cnt + 1'b1;
                    end
                end
            endcase
        end
    end

endmodule