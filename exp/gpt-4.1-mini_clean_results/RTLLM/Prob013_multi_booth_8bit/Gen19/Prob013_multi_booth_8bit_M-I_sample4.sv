module multi_booth_8bit (
    input             clk,
    input             reset,
    input      [7:0]  a,     // multiplier input
    input      [7:0]  b,     // multiplicand input
    output reg [15:0] p,     // product output
    output reg        rdy     // ready signal
);

    // States for FSM
    localparam IDLE = 2'd0;
    localparam LOAD = 2'd1;
    localparam CALC = 2'd2;

    reg [1:0] state, next_state;

    // Extended multiplicand with sign extension
    reg signed [16:0] multiplicand_ext; // 17 bits for signed addition/subtraction

    // Accumulator concatenates product and multiplier, plus extra bit for Booth encoding (total 17 bits)
    // acc[16:9]: upper 8 bits product (partial)
    // acc[8:1]: lower bits of multiplier (8 bits)
    // acc[0]: appended zero bit per Booth algorithm
    reg signed [16:0] acc, acc_next;

    // Counter: counts number of Radix-4 cycles (4 cycles for 8-bit multiplier)
    reg [2:0] ctr, ctr_next;

    // Internal signals for Booth encoding
    wire [2:0] booth_bits;
    reg signed [16:0] multplier_oper; // multiplicand multiple for addition/subtraction

    // Assign the 3 bits for booth recoding from acc
    assign booth_bits = {acc[1:0], 1'b0}; 
    // Actually, the 3 bits needed are acc[2:0], but acc[0] is always zero, so adjust:
    // We'll use acc[2:0], so define new wire
    wire [2:0] booth_code = acc[2:0];

    // Booth recoding: decide what to add/subtract
    // 3-bit patterns:
    // 000,111 -> 0
    // 001,010 -> +1 * multiplicand
    // 011 -> +2 * multiplicand
    // 100 -> -2 * multiplicand
    // 101,110 -> -1 * multiplicand
    always @(*) begin
        case (booth_code)
            3'b000,
            3'b111: multplier_oper = 17'sd0;
            3'b001,
            3'b010: multplier_oper = multiplicand_ext;
            3'b011: multplier_oper = multiplicand_ext <<< 1; // *2
            3'b100: multplier_oper = -(multiplicand_ext <<< 1); // -2 * multiplicand
            3'b101,
            3'b110: multplier_oper = -multiplicand_ext;
            default: multplier_oper = 17'sd0;
        endcase
    end

    // Sequential logic state register update
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            acc <= 17'd0;
            multiplicand_ext <= 17'd0;
            ctr <= 3'd0;
            p <= 16'd0;
            rdy <= 1'b0;
        end else begin
            state <= next_state;
            acc <= acc_next;
            multiplicand_ext <= multiplicand_ext; // multiplicand_ext stays unless loaded in LOAD state
            ctr <= ctr_next;
        end
    end

    // Next state and datapath logic
    always @(*) begin
        // Default assignments
        next_state = state;
        acc_next = acc;
        ctr_next = ctr;
        rdy = 1'b0;
        p = 16'd0;

        case(state)
            IDLE: begin
                rdy = 1'b0;
                if (!reset) begin
                    next_state = LOAD;
                end
            end

            LOAD: begin
                // Load multiplicand with sign extension
                multiplicand_ext = {{9{b[7]}}, b}; // 8 bits b + 9 bits sign ext to 17 bits

                // Initialize acc: product upper bits zero, multiplier lower bits = a, and appended zero bit = 0
                // a is multiplier, sign extend to 8 bits? For Booth, multiplier normally unsigned extended with 0 appended
                acc_next = {8'd0, a, 1'b0}; // 8 bits zero product, 8 bits multiplier, 1 zero bit appended

                ctr_next = 3'd0;
                next_state = CALC;
                rdy = 1'b0;
                p = 16'd0;
            end

            CALC: begin
                if (ctr < 3'd4) begin
                    // Perform addition/subtraction based on Booth recoding
                    // acc = acc + multplier_oper, then arithmetic right shift by 2 bits
                    acc_next = (acc + multplier_oper) >>> 2;

                    ctr_next = ctr + 1;

                    rdy = 1'b0;
                    p = 16'd0;

                    next_state = CALC;
                end else begin
                    // Finish multiplication
                    rdy = 1'b1;
                    // product is upper 16 bits of acc (excluding the appended 0 bit)
                    p = acc[16:1];
                    acc_next = acc;
                    ctr_next = ctr;
                    next_state = IDLE; // Return to IDLE after done
                end
            end

            default: begin
                next_state = IDLE;
                acc_next = 17'd0;
                ctr_next = 3'd0;
                rdy = 1'b0;
                p = 16'd0;
            end
        endcase
    end

endmodule