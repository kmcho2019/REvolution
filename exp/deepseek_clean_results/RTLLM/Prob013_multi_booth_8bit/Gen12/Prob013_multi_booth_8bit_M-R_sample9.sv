module multi_booth_8bit (
    input clk,
    input reset,
    input [7:0] a,
    input [7:0] b,
    output reg [15:0] p,
    output reg rdy
);

    // One-hot state encoding
    localparam INIT = 3'b001;
    localparam CALC = 3'b010;
    localparam DONE = 3'b100;
    reg [2:0] state, next_state;

    // Internal registers (9 bits for sign-extended 8-bit values)
    reg [8:0] multiplicand;
    reg [8:0] multiplier;
    reg prev_lsb;
    reg [2:0] iter_ctr;

    // Booth encoding wires
    wire [1:0] current_bits = multiplier[1:0];
    wire [2:0] booth_sel = {current_bits, prev_lsb};
    wire [15:0] booth_result;

    // Shift operations
    wire [8:0] multiplicand_shifted = multiplicand << 2;
    wire [8:0] multiplier_shifted = $signed(multiplier) >>> 2;

    // Clock gating signals
    wire calc_active = (state == CALC);
    wire update_regs = calc_active && (iter_ctr < 3'd4);

    // Booth encoding function (continuous assignment)
    assign booth_result = 
        (booth_sel == 3'b000 || booth_sel == 3'b111) ? 16'b0 :
        (booth_sel == 3'b001 || booth_sel == 3'b010) ? {{7{multiplicand[8]}}, multiplicand} :
        (booth_sel == 3'b101 || booth_sel == 3'b110) ? -{{7{multiplicand[8]}}, multiplicand} :
        (booth_sel == 3'b011) ? {{6{multiplicand[8]}}, multiplicand, 1'b0} :
        /* 3'b100 */ -{{6{multiplicand[8]}}, multiplicand, 1'b0};

    // State transition logic (combinational)
    always @(*) begin
        case (state)
            INIT: next_state = CALC;
            CALC: next_state = (iter_ctr == 3'd4) ? DONE : CALC;
            DONE: next_state = DONE;
            default: next_state = INIT;
        endcase
    end

    // Sequential logic
    always @(posedge clk) begin
        if (reset) begin
            state <= INIT;
            multiplicand <= {a[7], a};
            multiplier <= {b[7], b};
            prev_lsb <= 1'b0;
            p <= 16'b0;
            iter_ctr <= 3'b0;
            rdy <= 1'b0;
        end else begin
            state <= next_state;

            if (state == INIT) begin
                rdy <= 1'b0;
            end
            else if (state == CALC) begin
                p <= p + booth_result;
                
                if (update_regs) begin
                    multiplicand <= multiplicand_shifted;
                    multiplier <= multiplier_shifted;
                    prev_lsb <= current_bits[1];
                    iter_ctr <= iter_ctr + 1;
                end
            end
            else if (state == DONE) begin
                rdy <= 1'b1;
            end
        end
    end

endmodule