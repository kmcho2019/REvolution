module multi_16bit (
    input          clk,
    input          rst_n,   // synchronous active-low reset
    input          start,
    input  [15:0]  ain,
    input  [15:0]  bin,
    output [31:0]  yout,
    output         done
);

    // FSM states
    localparam IDLE = 1'b0;
    localparam BUSY = 1'b1;

    reg state, next_state;

    // Counter for shift count (0..17)
    reg [4:0] i;

    // Registers to hold multiplicand and multiplier shifts
    reg [15:0] areg;   // multiplicand shifted right
    reg [31:0] breg;   // multiplier shifted left (zero extended)

    // Product register (accumulator)
    reg [31:0] yout_r;

    // Done register
    reg done_r;

    // Next state logic combinational
    always @(*) begin
        case (state)
            IDLE: next_state = start ? BUSY : IDLE;
            BUSY: next_state = (i == 5'd17) ? IDLE : BUSY;
            default: next_state = IDLE;
        endcase
    end

    // Counter update
    always @(posedge clk) begin
        if (!rst_n)
            i <= 5'd0;
        else if (state == IDLE) begin
            if (start)
                i <= 5'd0;
            else
                i <= 5'd0;
        end else if (state == BUSY) begin
            if (i < 5'd17)
                i <= i + 5'd1;
            else
                i <= i;
        end else
            i <= i;
    end

    // State update
    always @(posedge clk) begin
        if (!rst_n)
            state <= IDLE;
        else
            state <= next_state;
    end

    // Done flag logic: done when i == 16 (one cycle before returning to IDLE)
    always @(posedge clk) begin
        if (!rst_n)
            done_r <= 1'b0;
        else if (state == BUSY && i == 5'd16)
            done_r <= 1'b1;
        else
            done_r <= 1'b0;
    end

    // Addition enable: only add when in BUSY state, within count 1..16, and LSB of areg is 1
    wire add_en = (state == BUSY) && (i >= 5'd1) && (i <= 5'd16) && (areg[0]);

    // Combinational adder result: current product + shifted multiplier
    wire [31:0] add_res = yout_r + breg;

    // Shift and accumulate logic
    always @(posedge clk) begin
        if (!rst_n) begin
            areg   <= 16'd0;
            breg   <= 32'd0;
            yout_r <= 32'd0;
        end else begin
            case (state)
                IDLE: begin
                    if (start) begin
                        // Load inputs at start of multiplication
                        areg   <= ain;
                        breg   <= {16'd0, bin}; // multiplier zero-extended to 32 bits
                        yout_r <= 32'd0;
                    end else begin
                        // Hold registers stable when idle and no start
                        areg   <= areg;
                        breg   <= breg;
                        yout_r <= yout_r;
                    end
                end
                BUSY: begin
                    if (i >= 5'd1 && i <= 5'd16) begin
                        // Conditionally accumulate if add_en asserted
                        if (add_en)
                            yout_r <= add_res;
                        else
                            yout_r <= yout_r;
                        // Shift multiplicand right and multiplier left for next bit
                        areg <= areg >> 1;
                        breg <= breg << 1;
                    end else begin
                        // During i=0 (load phase) or i=17 (done), hold registers
                        areg   <= areg;
                        breg   <= breg;
                        yout_r <= yout_r;
                    end
                end
                default: begin
                    areg   <= areg;
                    breg   <= breg;
                    yout_r <= yout_r;
                end
            endcase
        end
    end

    assign yout = yout_r;
    assign done = done_r;

endmodule