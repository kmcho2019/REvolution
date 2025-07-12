module multi_16bit (
    input          clk,
    input          rst_n,    // active-low synchronous reset
    input          start,
    input  [15:0]  ain,
    input  [15:0]  bin,
    output [31:0]  yout,
    output         done
);

    // FSM states
    localparam IDLE     = 2'd0;
    localparam LOAD     = 2'd1;
    localparam MULTIPLY = 2'd2;
    localparam DONE     = 2'd3;

    reg [1:0]   state, next_state;
    reg [4:0]   count;      // 0..16 multiplication cycles
    reg [15:0]  areg;
    reg [31:0]  breg;
    reg [31:0]  yout_r;
    reg         done_r;

    // FSM sequential state update
    always @(posedge clk) begin
        if (!rst_n)
            state <= IDLE;
        else
            state <= next_state;
    end

    // FSM next state logic
    always @(*) begin
        case(state)
            IDLE:     next_state = start ? LOAD : IDLE;
            LOAD:     next_state = MULTIPLY;
            MULTIPLY: next_state = (count == 5'd16) ? DONE : MULTIPLY;
            DONE:     next_state = (start == 1'b0) ? IDLE : DONE;
            default:  next_state = IDLE;
        endcase
    end

    // Counter for multiplication cycles, counts only in MULTIPLY
    always @(posedge clk) begin
        if (!rst_n)
            count <= 5'd0;
        else if (state == MULTIPLY)
            count <= count + 5'd1;
        else
            count <= 5'd0;
    end

    // Registers update with clock enable style control to reduce toggling
    always @(posedge clk) begin
        if (!rst_n) begin
            areg   <= 16'd0;
            breg   <= 32'd0;
            yout_r <= 32'd0;
            done_r <= 1'b0;
        end else begin
            case(state)
                IDLE: begin
                    // Hold registers stable, done low
                    areg   <= areg;
                    breg   <= breg;
                    yout_r <= yout_r;
                    done_r <= 1'b0;
                end

                LOAD: begin
                    // Load inputs and clear accumulator and done flag
                    areg   <= ain;
                    breg   <= {16'd0, bin};
                    yout_r <= 32'd0;
                    done_r <= 1'b0;
                end

                MULTIPLY: begin
                    // Accumulate only if LSB of areg is 1
                    if (areg[0])
                        yout_r <= yout_r + breg;
                    else
                        yout_r <= yout_r; // hold to avoid toggling

                    // Shift areg right and breg left for next bit
                    areg <= areg >> 1;
                    breg <= breg << 1;

                    done_r <= 1'b0;
                end

                DONE: begin
                    // Multiplication done, assert done flag
                    areg   <= areg;     // hold stable
                    breg   <= breg;     // hold stable
                    yout_r <= yout_r;   // hold stable
                    done_r <= 1'b1;
                end

                default: begin
                    areg   <= 16'd0;
                    breg   <= 32'd0;
                    yout_r <= 32'd0;
                    done_r <= 1'b0;
                end
            endcase
        end
    end

    assign yout = yout_r;
    assign done = done_r;

endmodule