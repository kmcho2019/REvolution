module multi_booth_8bit (
    input clk,
    input reset,
    input [7:0] a,      // multiplicand
    input [7:0] b,      // multiplier
    output reg [15:0] p, // product output
    output reg rdy       // ready signal
);

    // FSM states
    localparam IDLE = 2'b00;
    localparam CALC = 2'b01;
    localparam DONE = 2'b10;

    reg [1:0] state;

    // Extended multiplicand: 17 bits signed
    reg signed [16:0] multiplicand;

    // Product register holds:
    // Upper 17 bits accumulator part (signed)
    // Lower 9 bits: multiplier (8 bits) + appended zero bit (LSB)
    reg signed [25:0] product_reg;

    // Step counter: 0 to 3 for radix-4 steps
    reg [1:0] step_count;

    // Partial product for current step
    reg signed [16:0] partial_product;

    // Temporary signals for Booth encoding bits and calculation
    wire [2:0] booth_bits;
    assign booth_bits = product_reg[2:0];

    integer i; // for possible synthesis-friendly shifts

    // Extract product output from product_reg after computation:
    // Product is 16 bits composed of upper 16 bits of product_reg
    // Since product_reg = [accumulator(17 bits) | multiplier_ext(9 bits)],
    // final product is bits [24:9] (16 bits)
    // We'll assign this after completion

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // Initialization on reset:
            // Sign extend multiplicand to 17 bits
            multiplicand <= {{9{a[7]}}, a};

            // Product register setup: upper 17 bits zero (accumulator), lower 8 bits multiplier + appended zero bit LSB
            product_reg <= {{17{1'b0}}, b, 1'b0};

            step_count <= 2'd0;
            state <= CALC;
            rdy <= 1'b0;
            p <= 16'd0;
            partial_product <= 17'sd0;
        end else begin
            case (state)
                IDLE: begin
                    rdy <= 1'b0;
                    p <= 16'd0;
                    // Wait for reset to start
                end

                CALC: begin
                    // Determine partial product based on Booth encoding (3 LSB of product_reg)
                    case (booth_bits)
                        3'b000, 3'b111: partial_product <= 17'sd0;
                        3'b001, 3'b010: partial_product <= multiplicand;
                        3'b011:         partial_product <= multiplicand <<< 1; // *2
                        3'b100:         partial_product <= - (multiplicand <<< 1); // * -2
                        3'b101, 3'b110: partial_product <= - multiplicand;
                        default:        partial_product <= 17'sd0;
                    endcase

                    // Add partial product to upper 17 bits of product_reg (accumulator)
                    // product_reg: [25:9] = accumulator part, [8:0] multiplier + appended bit
                    // We'll add partial_product to product_reg[25:9]
                    // Use an intermediate 26-bit variable for addition

                    // Addition (signed)
                    product_reg[25:9] <= product_reg[25:9] + partial_product;

                    // Arithmetic right shift product_reg by 2 bits
                    // Implement arithmetic right shift preserving sign bit of accumulator
                    // Since product_reg is signed, use signed right shift operator (>>> 2)
                    product_reg <= product_reg >>> 2;

                    // Increment step count
                    step_count <= step_count + 1;

                    // When 4 steps complete, multiplication is done
                    if (step_count == 2'd3) begin
                        // Extract 16-bit product from product_reg
                        // product_reg[24:9] is 16 bits: final product
                        p <= product_reg[24:9];
                        rdy <= 1'b1;
                        state <= DONE;
                    end
                end

                DONE: begin
                    // Hold output and ready signal until reset
                    rdy <= 1'b1;
                    // p remains stable
                end

                default: begin
                    state <= IDLE;
                    rdy <= 1'b0;
                    p <= 16'd0;
                end
            endcase
        end
    end

endmodule