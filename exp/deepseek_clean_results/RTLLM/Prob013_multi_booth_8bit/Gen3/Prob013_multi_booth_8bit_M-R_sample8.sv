module multi_booth_8bit (
    input clk,
    input reset,
    input [7:0] a,
    input [7:0] b,
    output reg [15:0] p,
    output reg rdy
);

    // State definitions
    typedef enum {IDLE, CALC, DONE} state_t;
    state_t state;

    // Working registers
    reg [15:0] multiplicand;
    reg [15:0] multiplier;
    reg [1:0] ctr;  // 2-bit counter for 4 Radix-4 steps
    reg [15:0] partial_product;
    reg prev_bit;

    // Booth decoder outputs (combinational)
    wire [15:0] booth_pp;
    wire [1:0] booth_op;

    // Booth Radix-4 decoder
    assign booth_op = {multiplier[1:0], prev_bit};
    assign booth_pp = (booth_op == 3'b000 || booth_op == 3'b111) ? 16'b0 :
                     (booth_op == 3'b001 || booth_op == 3'b010) ? multiplicand :
                     (booth_op == 3'b011) ? (multiplicand << 1) :
                     (booth_op == 3'b100) ? -(multiplicand << 1) :
                     -multiplicand;  // cases 101,110

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            p <= 16'b0;
            rdy <= 1'b0;
            ctr <= 2'b0;
            prev_bit <= 1'b0;
        end else begin
            case (state)
                IDLE: begin
                    // Initialize registers
                    multiplicand <= {{8{a[7]}}, a};
                    multiplier <= {{8{b[7]}}, b};
                    p <= 16'b0;
                    ctr <= 2'b0;
                    prev_bit <= 1'b0;
                    state <= CALC;
                    rdy <= 1'b0;
                end

                CALC: begin
                    // Update product
                    p <= p + booth_pp;

                    // Shift multiplier and multiplicand
                    multiplier <= {2'b0, multiplier[15:2]};  // Logical right shift by 2
                    multiplicand <= multiplicand << 2;
                    prev_bit <= multiplier[1];

                    // Update counter and check completion
                    if (ctr == 2'b11) begin
                        state <= DONE;
                    end else begin
                        ctr <= ctr + 1;
                    end
                end

                DONE: begin
                    rdy <= 1'b1;
                    state <= IDLE;
                end
            endcase
        end
    end

endmodule