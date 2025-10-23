module multi_booth_8bit (
    input clk,
    input reset,
    input [7:0] a,
    input [7:0] b,
    output reg [15:0] p,
    output reg rdy
);

    // Pipeline stages
    reg [2:0] stage;
    localparam STAGE_INIT = 3'b001;
    localparam STAGE_COMPUTE = 3'b010;
    localparam STAGE_FINALIZE = 3'b100;

    // Operand registers
    reg [15:0] multiplicand;
    reg [15:0] multiplier;
    reg [15:0] product;
    reg [15:0] carry;

    // Booth encoding control
    reg [1:0] booth_group;
    reg [2:0] booth_bits;
    reg prev_bit;

    // Partial products
    wire [15:0] pp [0:4];
    wire [15:0] selected_pp;
    wire [15:0] sum, next_carry;

    // Generate all possible partial products
    assign pp[0] = 16'b0;                                    // 0
    assign pp[1] = multiplicand;                             // +1×M
    assign pp[2] = {multiplicand[14:0], 1'b0};               // +2×M
    assign pp[3] = ~{multiplicand[14:0], 1'b0} + 1'b1;       // -2×M
    assign pp[4] = ~multiplicand + 1'b1;                     // -1×M

    // Booth encoding selection
    assign booth_bits = {multiplier[1:0], prev_bit};
    assign selected_pp = 
        (booth_bits == 3'b000 || booth_bits == 3'b111) ? pp[0] :
        (booth_bits == 3'b001 || booth_bits == 3'b010) ? pp[1] :
        (booth_bits == 3'b011) ? pp[2] :
        (booth_bits == 3'b100) ? pp[3] : pp[4];

    // Carry-save addition
    assign sum = product ^ selected_pp ^ carry;
    assign next_carry = (product & selected_pp) | 
                       (product & carry) | 
                       (selected_pp & carry);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // Reset all registers
            stage <= STAGE_INIT;
            multiplicand <= 16'b0;
            multiplier <= 16'b0;
            product <= 16'b0;
            carry <= 16'b0;
            booth_group <= 2'b0;
            prev_bit <= 1'b0;
            p <= 16'b0;
            rdy <= 1'b0;
        end else begin
            case (stage)
                STAGE_INIT: begin
                    // Sign-extend inputs and initialize
                    multiplicand <= {{8{a[7]}}, a};
                    multiplier <= {{8{b[7]}}, b};
                    product <= 16'b0;
                    carry <= 16'b0;
                    booth_group <= 2'b0;
                    prev_bit <= 1'b0;
                    rdy <= 1'b0;
                    stage <= STAGE_COMPUTE;
                end

                STAGE_COMPUTE: begin
                    if (booth_group < 4) begin
                        // Accumulate partial product
                        product <= sum;
                        carry <= {next_carry[14:0], 1'b0};  // Left shift carry

                        // Shift multiplier and update booth bits
                        multiplier <= {{2{multiplier[15]}}, multiplier[15:2]};
                        prev_bit <= multiplier[1];
                        booth_group <= booth_group + 1;
                    end else begin
                        stage <= STAGE_FINALIZE;
                    end
                end

                STAGE_FINALIZE: begin
                    // Final addition (convert carry-save to binary)
                    p <= product + carry;
                    rdy <= 1'b1;
                    stage <= STAGE_INIT;
                end

                default: stage <= STAGE_INIT;
            endcase
        end
    end

endmodule