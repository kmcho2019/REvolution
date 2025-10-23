module multi_booth_8bit(
    input wire clk,
    input wire reset,
    input wire [7:0] a,
    input wire [7:0] b,
    output reg [15:0] p,
    output reg rdy
);

    // FSM States
    typedef enum logic [1:0] {
        IDLE = 2'b00,
        CALC = 2'b01,
        DONE = 2'b10
    } state_t;

    state_t state, next_state;

    // Internal registers
    reg signed [16:0] multiplicand;  // sign extended 'a' to 17 bits
    reg signed [8:0] multiplier;     // sign extended 'b' to 8 bits + appended zero LSB
    reg signed [17:0] product;       // 18-bit accumulator
    reg [2:0] ctr;                   // 0 to 4 (4 cycles for radix-4 on 8-bit)

    // Booth bits extraction
    // We select 3 bits: multiplier[2*ctr+1 : 2*ctr-1]
    // Since multiplier is 9 bits, this is safe for ctr in [0..3]
    wire [2:0] booth_bits;
    assign booth_bits = multiplier[2*ctr +1 -: 3];

    // Booth recoding combinational logic
    // Maps booth_bits to partial product signed value
    reg signed [17:0] booth_op;

    always @(*) begin
        case (booth_bits)
            3'b000,
            3'b111: booth_op = 18'sd0;
            3'b001,
            3'b010: booth_op = {multiplicand[16], multiplicand};       // +1 * multiplicand
            3'b011: booth_op = {multiplicand[16], multiplicand} <<< 1; // +2 * multiplicand
            3'b100: booth_op = -({multiplicand[16], multiplicand} <<< 1);// -2 * multiplicand
            3'b101,
            3'b110: booth_op = -{multiplicand[16], multiplicand};      // -1 * multiplicand
            default: booth_op = 18'sd0;
        endcase
    end

    // FSM Sequential Logic
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            rdy <= 1'b0;
            p <= 16'd0;
            // Load and sign extend inputs
            multiplicand <= {{9{a[7]}}, a};  // 17-bit sign extension
            multiplier <= {{1{b[7]}}, b, 1'b0}; // sign extend b (8 bits) + appended 0 => 9 bits
            product <= 18'sd0;
            ctr <= 3'd0;
        end else begin
            state <= next_state;
            case(state)
                IDLE: begin
                    rdy <= 1'b0;
                    p <= 16'd0;
                    // Hold inputs steady; multiplicand and multiplier already loaded on reset
                    product <= 18'sd0;
                    ctr <= 3'd0;
                end
                CALC: begin
                    // Calculate partial product: shift right by 2 bits arithmetic + booth_op addition
                    product <= (product >>> 2) + booth_op;
                    ctr <= ctr + 3'd1;
                end
                DONE: begin
                    rdy <= 1'b1;
                    p <= product[15:0];
                    // Hold product and ready until reset
                end
            endcase
        end
    end

    // FSM Combinational Next State Logic
    always @(*) begin
        case(state)
            IDLE: next_state = CALC;
            CALC: next_state = (ctr == 3'd4) ? DONE : CALC;
            DONE: next_state = DONE;
            default: next_state = IDLE;
        endcase
    end

endmodule