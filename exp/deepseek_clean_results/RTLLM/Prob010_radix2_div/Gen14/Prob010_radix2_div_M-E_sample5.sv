module radix2_div (
    input clk,
    input rst,
    input sign,
    input [7:0] dividend,
    input [7:0] divisor,
    input opn_valid,
    output reg res_valid,
    output reg [15:0] result
);

// Pipeline registers
reg [7:0] stage1_divisor, stage1_dividend;
reg stage1_sign, stage1_valid;
reg [7:0] stage2_divisor, stage2_dividend;
reg stage2_sign, stage2_valid;

// Division state machine
localparam IDLE = 0;
localparam PROCESSING = 1;
reg state;
reg [2:0] cnt;  // 0-7 counter

// Division registers
reg [15:0] acc;  // {remainder, quotient}
reg [7:0] neg_divisor;

// Intermediate signals
wire [7:0] abs_dividend = stage1_dividend[7] ? -stage1_dividend : stage1_dividend;
wire [7:0] abs_divisor = stage1_divisor[7] ? -stage1_divisor : stage1_divisor;
wire div_by_zero = (abs_divisor == 0);

// Result sign calculation
wire q_sign = stage2_sign & (stage2_dividend[7] ^ stage2_divisor[7]);
wire r_sign = stage2_sign & stage2_dividend[7];

// Division step logic
wire [8:0] sub_result = {acc[15:8], 1'b0} + {1'b0, neg_divisor};
wire carry_out = ~sub_result[8];
wire [15:0] next_acc = carry_out ? 
    {sub_result[7:0], acc[7:0], 1'b1} : 
    {acc[14:0], 1'b0};

always @(posedge clk or posedge rst) begin
    if (rst) begin
        // Reset all pipeline registers
        stage1_valid <= 0;
        stage2_valid <= 0;
        res_valid <= 0;
        state <= IDLE;
        cnt <= 0;
        acc <= 0;
        result <= 0;
    end else begin
        // Pipeline stage 1: Input registration and preprocessing
        if (opn_valid) begin
            stage1_dividend <= dividend;
            stage1_divisor <= divisor;
            stage1_sign <= sign;
            stage1_valid <= 1;
        end else begin
            stage1_valid <= 0;
        end

        // Pipeline stage 2: Core division logic
        stage2_valid <= stage1_valid;
        if (stage1_valid) begin
            stage2_dividend <= abs_dividend;
            stage2_divisor <= abs_divisor;
            stage2_sign <= stage1_sign;
            neg_divisor <= ~abs_divisor + 1;
        end

        // Division state machine
        case (state)
            IDLE: begin
                res_valid <= 0;
                if (stage2_valid) begin
                    acc <= {8'b0, stage2_dividend};
                    cnt <= 0;
                    state <= PROCESSING;
                end
            end

            PROCESSING: begin
                if (div_by_zero) begin
                    // Handle division by zero
                    result <= {8'hFF, 8'hFF};
                    res_valid <= 1;
                    state <= IDLE;
                end else if (cnt == 3'b111) begin
                    // Final adjustment for non-restoring division
                    if (acc[15]) begin
                        acc[15:8] <= acc[15:8] + stage2_divisor;
                    end

                    // Apply signs to result
                    result <= {
                        r_sign ? -acc[15:8] : acc[15:8],  // remainder
                        q_sign ? -acc[7:0] : acc[7:0]      // quotient
                    };

                    res_valid <= 1;
                    state <= IDLE;
                end else begin
                    // Normal iteration
                    acc <= next_acc;
                    cnt <= cnt + 1;
                end
            end
        endcase
    end
end

endmodule