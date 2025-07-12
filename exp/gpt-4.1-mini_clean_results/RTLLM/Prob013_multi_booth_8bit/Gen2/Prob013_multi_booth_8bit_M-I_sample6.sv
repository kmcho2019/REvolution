module multi_booth_8bit (
    input clk,
    input reset,
    input [7:0] a,      // multiplicand
    input [7:0] b,      // multiplier
    output reg [15:0] p, // product
    output reg rdy
);

    // State encoding
    parameter IDLE = 2'b00;
    parameter CALC = 2'b01;
    parameter DONE = 2'b10;

    reg [1:0] state;

    // Extended registers (17 bits to hold sign-extended values and overflow)
    reg signed [16:0] multiplicand; // multiplicand extended to 17 bits
    reg signed [16:0] accumulator;  // accumulator part, initialized to 0
    reg [9:0] multiplier_ext;       // multiplier extended with appended zero bits (9 bits: 8 bits + 1 zero LSB)
    reg [2:0] booth_bits;           // current 3-bit window for Booth recoding
    reg [2:0] step_count;           // counts radix-4 cycles (0 to 3) - total 4 cycles for 8 bits

    // Internal signals
    reg signed [16:0] partial_product;

    // Sign extend inputs on reset
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            multiplicand <= {{9{a[7]}}, a}; // sign extend 8-bit multiplicand to 17 bits
            accumulator <= 17'sd0;
            multiplier_ext <= {b, 1'b0};   // multiplier with appended zero bit for Booth
            step_count <= 3'd0;
            state <= CALC;
            rdy <= 1'b0;
            p <= 16'd0;
        end else begin
            case (state)
                IDLE: begin
                    rdy <= 1'b0;
                    p <= 16'd0;
                    // Wait here until reset starts calculation
                end
                CALC: begin
                    // Extract 3 bits for Booth encoding: multiplier_ext[1:0] + extra bit multiplier_ext[2]
                    booth_bits = multiplier_ext[2:0];

                    // Determine partial product based on Booth encoding radix-4
                    // Booth recoding radix-4:
                    // 000,111 => 0
                    // 001,010 => +1 * multiplicand
                    // 011     => +2 * multiplicand
                    // 100     => -2 * multiplicand
                    // 101,110 => -1 * multiplicand
                    case (booth_bits)
                        3'b000,
                        3'b111: partial_product = 17'sd0;
                        3'b001,
                        3'b010: partial_product = multiplicand;
                        3'b011: partial_product = multiplicand <<< 1; // *2
                        3'b100: partial_product = - (multiplicand <<< 1); // * -2
                        3'b101,
                        3'b110: partial_product = - multiplicand;
                        default: partial_product = 17'sd0;
                    endcase

                    // Add partial product to accumulator
                    accumulator <= accumulator + partial_product;

                    // Arithmetic right shift multiplier_ext and accumulator by 2 bits together
                    // Combine accumulator and multiplier_ext into a 27-bit signed quantity: [accumulator(17) | multiplier_ext(10)]
                    // Then arithmetic shift right by 2 bits
                    // Update accumulator and multiplier_ext accordingly

                    // Combine for shift: 27 bits signed
                    // Need temporary variable for shift operation
                    reg signed [26:0] combined;
                    combined = {accumulator, multiplier_ext};
                    combined = combined >>> 2;

                    // Update registers after shift
                    accumulator <= combined[26:10];
                    multiplier_ext <= combined[9:0];

                    // Increment step counter
                    step_count <= step_count + 1;

                    // Check if multiplication done after 4 steps (since radix-4 works on pairs)
                    if (step_count == 3'd3) begin
                        // Multiplication complete
                        p <= {accumulator[15:0], multiplier_ext[9:1]}; // product is upper 16 bits accumulator + upper 8 bits multiplier_ext (excluding appended bits)
                        rdy <= 1'b1;
                        state <= DONE;
                    end
                end
                DONE: begin
                    // Hold output, waiting for reset
                    rdy <= 1'b1;
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