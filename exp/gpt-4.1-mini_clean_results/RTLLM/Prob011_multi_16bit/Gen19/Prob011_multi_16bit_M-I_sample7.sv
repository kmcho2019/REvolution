module multi_16bit (
    input          clk,
    input          rst_n,
    input          start,
    input  [15:0]  ain,
    input  [15:0]  bin,
    output [31:0]  yout,
    output         done
);

    // State machine states
    localparam IDLE    = 2'd0;
    localparam RUNNING = 2'd1;
    localparam DONE    = 2'd2;

    reg [1:0]    state, next_state;
    reg [4:0]    i;          // shift count (0 to 16)
    reg [15:0]   areg;
    reg [31:0]   breg_ext;
    reg [31:0]   yout_r;

    // Sequential state register
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            state <= IDLE;
        else
            state <= next_state;
    end

    // Next state logic
    always @(*) begin
        case (state)
            IDLE: begin
                if (start)
                    next_state = RUNNING;
                else
                    next_state = IDLE;
            end
            RUNNING: begin
                if (i == 5'd16)
                    next_state = DONE;
                else
                    next_state = RUNNING;
            end
            DONE: begin
                if (!start)
                    next_state = IDLE;
                else
                    next_state = DONE;
            end
            default: next_state = IDLE;
        endcase
    end

    // Shift count register with enable only in RUNNING state
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            i <= 5'd0;
        else if (state == IDLE)
            i <= 5'd0;
        else if (state == RUNNING)
            i <= i + 5'd1;
        else
            i <= i;  // hold in DONE state
    end

    // Registers update logic with clock enables
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            areg    <= 16'd0;
            breg_ext <= 32'd0;
            yout_r  <= 32'd0;
        end else begin
            case (state)
                IDLE: begin
                    areg    <= 16'd0;
                    breg_ext <= 32'd0;
                    yout_r  <= 32'd0;
                end
                RUNNING: begin
                    if (i == 5'd0) begin
                        // Load inputs at start of RUNNING
                        areg    <= ain;
                        breg_ext <= {16'd0, bin};
                        yout_r  <= 32'd0;
                    end else if (i <= 5'd16) begin
                        // Accumulate if LSB of areg is set
                        if (areg[0])
                            yout_r <= yout_r + breg_ext;
                        else
                            yout_r <= yout_r;  // hold accumulator if no add
                        // Shift for next bit
                        areg    <= areg >> 1;
                        breg_ext <= breg_ext << 1;
                    end
                end
                DONE: begin
                    // Hold registers - no changes
                    areg    <= areg;
                    breg_ext <= breg_ext;
                    yout_r  <= yout_r;
                end
                default: begin
                    areg    <= 16'd0;
                    breg_ext <= 32'd0;
                    yout_r  <= 32'd0;
                end
            endcase
        end
    end

    // Done flag asserted only in DONE state
    assign done = (state == DONE);
    assign yout = yout_r;

endmodule