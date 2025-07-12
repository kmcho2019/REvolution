module multi_booth_8bit(
    input clk,
    input reset,
    input [7:0] a,        // multiplicand
    input [7:0] b,        // multiplier
    output reg [15:0] p,  // product
    output reg rdy
);

    // States for FSM
    typedef enum logic [1:0] {
        IDLE = 2'b00,
        CALC = 2'b01,
        DONE = 2'b10
    } state_t;

    state_t state, next_state;

    // Internal registers
    reg signed [16:0] multiplicand_ext; // sign-extended multiplicand
    reg signed [16:0] A_reg;             // accumulator (17 bits signed)
    reg [8:0] Q_reg;                     // multiplier plus appended zero bit
    reg [3:0] ctr;                      // count from 0 to 8 (8 cycles)

    // Extract 3 bits for Booth encoding: Q_reg[2:0] = {Q_i+1, Q_i, Q_i-1}
    wire [2:0] booth_bits = Q_reg[2:0];

    // Compute Booth operation result combinationally
    reg signed [16:0] add_sub_val;
    always @(*) begin
        case(booth_bits)
            3'b000, 3'b111: add_sub_val = 17'sd0;
            3'b001, 3'b010: add_sub_val = multiplicand_ext;
            3'b011:         add_sub_val = multiplicand_ext <<< 1;    // * 2
            3'b100:         add_sub_val = -(multiplicand_ext <<< 1); // * -2
            3'b101, 3'b110: add_sub_val = -multiplicand_ext;
            default:        add_sub_val = 17'sd0;
        endcase
    end

    // Combined 26-bit signed value for shift: {A_reg, Q_reg}
    wire signed [25:0] combined_before_shift = {A_reg, Q_reg};
    wire signed [25:0] combined_after_shift = combined_before_shift >>> 2;

    // Next values for registers after shift and add/sub
    wire signed [16:0] A_next = combined_after_shift[25:9];
    wire [8:0] Q_next = combined_after_shift[8:0];

    // FSM sequential logic
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // Initialize on reset
            multiplicand_ext <= {{9{a[7]}}, a};      // sign-extend to 17 bits
            A_reg <= 17'sd0;
            Q_reg <= {b, 1'b0};                      // multiplier + appended zero bit
            ctr <= 4'd0;
            state <= CALC;
            rdy <= 1'b0;
            p <= 16'd0;
        end else begin
            state <= next_state;
            case(state)
                IDLE: begin
                    // Do nothing here; wait for reset to start calculation
                    rdy <= 1'b0;
                    p <= 16'd0;
                end
                CALC: begin
                    if (ctr < 4'd8) begin
                        // Add/subtract according to Booth encoding
                        A_reg <= A_reg + add_sub_val;
                        // Shift right arithmetic by 2 combined
                        // Do shifts and update A_reg and Q_reg after addition in next clock cycle
                        // But to keep synchronous update, combine steps:
                        // First add add_sub_val to A_reg (registered above), then update A_reg and Q_reg with shifted result
                        // To avoid data race, use intermediate registers:

                        // We will perform these two steps in sequence inside the same cycle:
                        // 1) Add add_sub_val to A_reg
                        // 2) Shift combined (A_reg + add_sub_val, Q_reg) right 2 bits

                        // However, nonblocking assignments execute in parallel, so this direct approach will not work perfectly.
                        // We implement it in two sequential clock cycles by splitting logic or by restructuring.

                        // To respect one cycle per iteration, we perform:
                        // Use combinational logic to get sum = A_reg + add_sub_val,
                        // then update A_reg and Q_reg with shifted sum combined with Q_reg.

                        // So we create intermediate signals:

                        // This requires an extra register for A_reg + add_sub_val to hold sum before shifting

                    end
                    // Update counter
                    ctr <= ctr + 1'b1;
                end
                DONE: begin
                    rdy <= 1'b1;
                    p <= {A_reg[15:0], Q_reg[8:1]}; // product from accumulator and multiplier parts
                end
            endcase
        end
    end

    // Separate registers to hold intermediate sum and shifted results

    // Intermediate sum after addition
    reg signed [16:0] sum_A;
    reg [8:0] Q_next_reg;
    reg signed [16:0] A_next_reg;

    always @(*) begin
        sum_A = A_reg + add_sub_val;                     // sum of accumulator + partial product
        // Combine sum_A and Q_reg for shifting
        // combined = {sum_A, Q_reg}
        // Arithmetic right shift by 2
        reg signed [25:0] combined_temp;
        combined_temp = {sum_A, Q_reg} >>> 2;
        A_next_reg = combined_temp[25:9];
        Q_next_reg = combined_temp[8:0];
    end

    // Another always block to update registers synchronously after combinational calculation
    always @(posedge clk) begin
        if (state == CALC && ctr < 4'd8) begin
            A_reg <= A_next_reg;
            Q_reg <= Q_next_reg;
            ctr <= ctr + 1'b1;
            if (ctr == 4'd7) begin
                state <= DONE;
            end
        end else if (state == IDLE) begin
            // Waiting for reset to start multiplication
            A_reg <= 17'sd0;
            Q_reg <= 9'd0;
            ctr <= 4'd0;
            rdy <= 1'b0;
            p <= 16'd0;
        end
    end

endmodule