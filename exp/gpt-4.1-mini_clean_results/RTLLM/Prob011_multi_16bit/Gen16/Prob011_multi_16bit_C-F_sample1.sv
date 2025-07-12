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
    localparam IDLE = 1'b0;
    localparam BUSY = 1'b1;

    reg         state, next_state;
    reg [4:0]   count;        // shift count: 0 to 16
    reg [15:0]  areg;         // shifted multiplicand bits (regarded as multiplier bits per original spec)
    reg [31:0]  breg_ext;     // extended multiplier, shifted left each cycle
    reg [31:0]  yout_r;       // product accumulator
    reg         done_r;

    // FSM next state logic
    always @(*) begin
        case (state)
            IDLE: next_state = start ? BUSY : IDLE;
            BUSY: next_state = (count == 5'd16) ? IDLE : BUSY;
            default: next_state = IDLE;
        endcase
    end

    // FSM and count update
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
            count <= 5'd0;
        end else begin
            state <= next_state;
            if (state == IDLE) begin
                if (start)
                    count <= 5'd0;
                else
                    count <= 5'd0;
            end else if (state == BUSY) begin
                if (count < 5'd16)
                    count <= count + 5'd1;
            end
        end
    end

    // Registers and product update
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            areg    <= 16'd0;
            breg_ext <= 32'd0;
            yout_r  <= 32'd0;
            done_r  <= 1'b0;
        end else begin
            case (state)
                IDLE: begin
                    done_r <= 1'b0;
                    if (start) begin
                        // Load inputs at start
                        areg    <= ain;
                        breg_ext <= {16'd0, bin}; // multiplier in lower 16 bits
                        yout_r  <= 32'd0;
                    end
                end

                BUSY: begin
                    // Accumulate if LSB of areg is 1
                    if (areg[0])
                        yout_r <= yout_r + breg_ext;
                    else
                        yout_r <= yout_r;  // Hold to avoid latches, but can be omitted

                    // Shift registers for next iteration
                    areg    <= areg >> 1;
                    breg_ext <= breg_ext << 1;

                    // Set done flag at count == 16
                    if (count == 5'd16)
                        done_r <= 1'b1;
                end

                default: begin
                    areg    <= 16'd0;
                    breg_ext <= 32'd0;
                    yout_r  <= 32'd0;
                    done_r  <= 1'b0;
                end
            endcase
        end
    end

    assign yout = yout_r;
    assign done = done_r;

endmodule