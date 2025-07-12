module multi_booth_8bit (
    input clk,
    input reset,
    input [7:0] a,
    input [7:0] b,
    output reg [15:0] p,
    output reg rdy
);

    // Pipeline stages
    typedef enum {IDLE, PP_GEN, REDUCE, FINISH} state_t;
    reg [1:0] state, next_state;

    // Partial product registers
    reg [15:0] pp0, pp1, pp2, pp3;
    reg [15:0] sum_stage1, carry_stage1;
    reg [15:0] final_sum;

    // Control signals
    wire zero_multiplier = (b == 8'b0);
    wire early_done;
    reg [1:0] pipe_ctr;

    // Booth encoding (parallel generation)
    always @(*) begin
        // Generate all partial products in parallel
        case (b[1:0])
            2'b00: pp0 = 16'b0;
            2'b01: pp0 = {{8{a[7]}}, a};
            2'b10: pp0 = {{8{a[7]}}, a} << 1;
            2'b11: pp0 = -({{8{a[7]}}, a} << 1);
        endcase

        case (b[3:2])
            2'b00: pp1 = 16'b0;
            2'b01: pp1 = {{8{a[7]}}, a} << 2;
            2'b10: pp1 = {{8{a[7]}}, a} << 3;
            2'b11: pp1 = -({{8{a[7]}}, a} << 3);
        endcase

        case (b[5:4])
            2'b00: pp2 = 16'b0;
            2'b01: pp2 = {{8{a[7]}}, a} << 4;
            2'b10: pp2 = {{8{a[7]}}, a} << 5;
            2'b11: pp2 = -({{8{a[7]}}, a} << 5);
        endcase

        case (b[7:6])
            2'b00: pp3 = 16'b0;
            2'b01: pp3 = {{8{a[7]}}, a} << 6;
            2'b10: pp3 = {{8{a[7]}}, a} << 7;
            2'b11: pp3 = -({{8{a[7]}}, a} << 7);
        endcase
    end

    // Wallace tree reduction (stage 1)
    always @(posedge clk) begin
        if (reset) begin
            sum_stage1 <= 16'b0;
            carry_stage1 <= 16'b0;
        end else if (state == PP_GEN) begin
            // First level CSA
            sum_stage1 <= pp0 ^ pp1 ^ pp2;
            carry_stage1 <= ((pp0 & pp1) | (pp0 & pp2) | (pp1 & pp2)) << 1;
        end
    end

    // Final addition (stage 2)
    always @(posedge clk) begin
        if (reset) begin
            final_sum <= 16'b0;
        end else if (state == REDUCE) begin
            // Second level CSA + final addition
            final_sum <= sum_stage1 + carry_stage1 + pp3;
        end
    end

    // Control FSM
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            pipe_ctr <= 2'b0;
            rdy <= 1'b0;
            p <= 16'b0;
        end else begin
            state <= next_state;
            
            case (state)
                IDLE: begin
                    if (!zero_multiplier) begin
                        pipe_ctr <= 2'b0;
                    end
                end
                
                PP_GEN: begin
                    pipe_ctr <= pipe_ctr + 1;
                end
                
                REDUCE: begin
                    pipe_ctr <= pipe_ctr + 1;
                end
                
                FINISH: begin
                    p <= final_sum;
                    rdy <= 1'b1;
                end
            endcase
        end
    end

    // Next state logic
    always @(*) begin
        case (state)
            IDLE: next_state = (zero_multiplier) ? FINISH : PP_GEN;
            PP_GEN: next_state = (pipe_ctr == 2'd1) ? REDUCE : PP_GEN;
            REDUCE: next_state = (pipe_ctr == 2'd3) ? FINISH : REDUCE;
            FINISH: next_state = IDLE;
            default: next_state = IDLE;
        endcase
    end

    // Early completion detection
    assign early_done = (state == FINISH) || (zero_multiplier && (state == IDLE));

    // Ready signal
    always @(posedge clk) begin
        if (reset) begin
            rdy <= 1'b0;
        end else begin
            rdy <= early_done;
        end
    end

endmodule