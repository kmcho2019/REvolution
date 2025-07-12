module multi_booth_8bit (
    input clk,
    input reset,
    input [7:0] a,
    input [7:0] b,
    output reg [15:0] p,
    output reg rdy
);

    // FSM states
    typedef enum logic [1:0] {
        IDLE,
        PROCESS,
        DONE
    } state_t;

    state_t current_state, next_state;

    // Datapath registers
    reg [16:0] A_reg;    // Multiplicand with sign extension + guard bit
    reg [8:0] B_reg;     // Multiplier with sign extension
    reg [2:0] cycle_cnt; // Only need 0-3 for 8-bit Radix-4
    reg [15:0] accum;

    // Booth encoder signals
    wire [2:0] booth_bits;
    wire [15:0] pp_select;
    wire [15:0] pp_shifted;

    // Booth encoding
    assign booth_bits = (cycle_cnt == 0) ? {B_reg[1:0], 1'b0} : 
                       {B_reg[2*cycle_cnt +: 2], B_reg[2*cycle_cnt-1]};

    // Partial product selection
    assign pp_select = (booth_bits == 3'b001 || booth_bits == 3'b010) ? A_reg[16:1] :
                      (booth_bits == 3'b011) ? {A_reg[15:1], 1'b0} :
                      (booth_bits == 3'b100) ? ~{A_reg[15:1], 1'b0} + 1'b1 :
                      (booth_bits == 3'b101 || booth_bits == 3'b110) ? ~A_reg[16:1] + 1'b1 :
                      16'b0;

    // Partial product shifting
    assign pp_shifted = pp_select << (2*cycle_cnt);

    // Early completion detection
    wire early_done = (B_reg[8:2*cycle_cnt+2] == {7{B_reg[8]}}) && (current_state == PROCESS);

    // State machine
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            current_state <= IDLE;
            A_reg <= 17'b0;
            B_reg <= 9'b0;
            accum <= 16'b0;
            p <= 16'b0;
            rdy <= 1'b0;
            cycle_cnt <= 3'b0;
        end else begin
            current_state <= next_state;

            case (current_state)
                IDLE: begin
                    A_reg <= {{9{a[7]}}, a[7:0]};  // Sign extend multiplicand
                    B_reg <= {b[7], b[7:0]};       // Sign extend multiplier
                    accum <= 16'b0;
                    cycle_cnt <= 3'b0;
                end

                PROCESS: begin
                    accum <= accum + pp_shifted;
                    B_reg <= {B_reg[8], B_reg[8:1]};  // Arithmetic right shift
                    cycle_cnt <= cycle_cnt + 1;
                end

                DONE: begin
                    p <= accum;
                    rdy <= 1'b1;
                end
            endcase
        end
    end

    // Next state logic
    always_comb begin
        next_state = current_state;
        case (current_state)
            IDLE: next_state = PROCESS;
            PROCESS: begin
                if (early_done || cycle_cnt == 3)
                    next_state = DONE;
            end
            DONE: next_state = IDLE;
        endcase
    end

endmodule