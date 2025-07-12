module multi_16bit (
    input          clk,
    input          rst_n,
    input          start,
    input  [15:0]  ain,
    input  [15:0]  bin,
    output [31:0]  yout,
    output         done
);

    // FSM states
    typedef enum logic [1:0] {
        IDLE = 2'b00,
        RUN  = 2'b01,
        DONE = 2'b10
    } state_t;

    state_t state, next_state;

    reg [4:0]  i;       // shift count: 0 to 17
    reg        done_r;

    reg [31:0] areg;    // shifted multiplicand
    reg [15:0] breg;    // shifting multiplier
    reg [31:0] yout_r;  // accumulator

    // Next state logic
    always @(*) begin
        case (state)
            IDLE:    next_state = (start) ? RUN : IDLE;
            RUN:     next_state = (i == 5'd16) ? DONE : RUN;
            DONE:    next_state = (!start) ? IDLE : DONE;
            default: next_state = IDLE;
        endcase
    end

    // State register
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            state <= IDLE;
        else
            state <= next_state;
    end

    // Control signals
    wire cnt_enable  = (state == RUN);
    wire load_regs   = (state == RUN) && (i == 5'd0);
    wire accumulate  = (state == RUN) && (i >= 5'd1) && (i <= 5'd16);

    // Shift count (i) update
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            i <= 5'd0;
        else if (state == IDLE)
            i <= 5'd0;
        else if (cnt_enable)
            i <= i + 5'd1;
    end

    // Registers update
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            areg   <= 32'd0;
            breg   <= 16'd0;
            yout_r <= 32'd0;
        end else if (state == IDLE) begin
            areg   <= 32'd0;
            breg   <= 16'd0;
            yout_r <= 32'd0;
        end else if (load_regs) begin
            areg   <= {16'd0, ain};  // Load multiplicand at LSB side
            breg   <= bin;           // Load multiplier
            yout_r <= 32'd0;
        end else if (accumulate) begin
            if (areg[i-1])
                yout_r <= yout_r + (breg << (i - 1));
        end
    end

    // Done flag update
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            done_r <= 1'b0;
        else if (state == DONE)
            done_r <= 1'b1;
        else
            done_r <= 1'b0;
    end

    assign yout = yout_r;
    assign done = done_r;

endmodule