module radix2_div (
    input              clk,
    input              rst,
    input              sign,           // 1: signed, 0: unsigned
    input      [7:0]   dividend,
    input      [7:0]   divisor,
    input              opn_valid,
    output reg         res_valid,
    output reg [15:0]  result           // {remainder[7:0], quotient[7:0]}
);

    // State encoding
    localparam IDLE    = 2'd0;
    localparam RUNNING = 2'd1;
    localparam DONE    = 2'd2;

    reg [1:0] state, next_state;

    // Registers to hold inputs and internal variables
    reg [7:0] dividend_r;
    reg [7:0] divisor_r;
    reg dividend_neg;
    reg divisor_neg;
    reg [7:0] abs_dividend;
    reg [7:0] abs_divisor;

    // Shift register: 17 bits {remainder[8:0], quotient[7:0]} as per design
    reg [16:0] SR;

    // Counter for division steps (1 to 8)
    reg [3:0] cnt;

    // Negated divisor magnitude (9-bit two's complement)
    wire [8:0] divisor_mag_9 = {1'b0, abs_divisor};
    wire [8:0] neg_divisor = (~divisor_mag_9) + 9'b1;

    // Current remainder (upper 9 bits of SR)
    wire [8:0] remainder_part = SR[16:8];

    // Subtraction result: remainder_part - divisor_mag (implemented as remainder_part + neg_divisor)
    wire [9:0] sub_full = {1'b0, remainder_part} + {1'b0, neg_divisor};
    wire borrow_sub = ~sub_full[9];  // borrow occurs if highest bit is 0 after addition

    wire [8:0] sub_res = sub_full[8:0];

    // Quotient bit decision:
    // If borrow_sub == 0, subtraction succeeded => quotient bit = 1
    // Else quotient bit = 0 and remainder unchanged

    // Next value of SR based on subtraction result and shift left by 1
    wire [16:0] SR_next = !borrow_sub ?
        {sub_res, SR[7:1], 1'b1} :    // subtraction successful, append '1' to quotient
        {remainder_part, SR[7:1], 1'b0}; // subtraction failed, append '0' to quotient

    // Sign corrections
    wire quotient_neg = sign & (dividend_neg ^ divisor_neg);
    wire remainder_neg = sign & dividend_neg;

    // Raw quotient and remainder extracted when done:
    wire [7:0] raw_quotient = SR[7:0];
    wire [7:0] raw_remainder = SR[16:9]; // discard lowest remainder bit SR[8]

    wire [7:0] quotient_corr = quotient_neg ? (~raw_quotient + 8'd1) : raw_quotient;
    wire [7:0] remainder_corr = remainder_neg ? (~raw_remainder + 8'd1) : raw_remainder;

    // Sequential logic for state machine and registers
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state        <= IDLE;
            dividend_r   <= 8'd0;
            divisor_r    <= 8'd0;
            dividend_neg <= 1'b0;
            divisor_neg  <= 1'b0;
            abs_dividend <= 8'd0;
            abs_divisor  <= 8'd0;
            SR           <= 17'd0;
            cnt          <= 4'd0;
            res_valid    <= 1'b0;
            result       <= 16'd0;
        end else begin
            state <= next_state;

            case (state)
                IDLE: begin
                    res_valid <= 1'b0;
                    if (opn_valid) begin
                        // Latch inputs and compute abs and sign flags
                        dividend_r <= dividend;
                        divisor_r <= divisor;

                        if (sign) begin
                            dividend_neg <= dividend[7];
                            divisor_neg  <= divisor[7];
                            abs_dividend <= dividend[7] ? (~dividend + 8'd1) : dividend;
                            abs_divisor  <= divisor[7] ? (~divisor + 8'd1) : divisor;
                        end else begin
                            dividend_neg <= 1'b0;
                            divisor_neg  <= 1'b0;
                            abs_dividend <= dividend;
                            abs_divisor  <= divisor;
                        end

                        // Initialize SR: remainder = 0, quotient = abs_dividend shifted left by 1 (multiply by 2)
                        // Place quotient in lower 9 bits (8 bits + 1 zero bit)
                        SR <= {9'd0, abs_dividend, 1'b0};

                        cnt <= 4'd1;
                    end
                end

                RUNNING: begin
                    // Perform one division iteration per clock cycle
                    SR <= SR_next;
                    cnt <= cnt + 1'b1;
                end

                DONE: begin
                    // Assert res_valid and output corrected result
                    res_valid <= 1'b1;
                    result <= {remainder_corr, quotient_corr};
                end
            endcase
        end
    end

    // Next state combinational logic
    always @(*) begin
        next_state = state;
        case (state)
            IDLE: begin
                if (opn_valid)
                    next_state = RUNNING;
            end

            RUNNING: begin
                if (cnt[3]) // cnt >= 8 (since counting from 1, bit3 high means >=8)
                    next_state = DONE;
            end

            DONE: begin
                if (!opn_valid)
                    next_state = IDLE;
            end
        endcase
    end

endmodule