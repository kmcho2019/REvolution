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
    reg [4:0]   count;      // 0..16 cycles
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

    // Counter for multiplication cycles
    always @(posedge clk) begin
        if (!rst_n)
            count <= 5'd0;
        else if (state == MULTIPLY)
            count <= count + 5'd1;
        else
            count <= 5'd0;
    end

    // Registers update
    always @(posedge clk) begin
        if (!rst_n) begin
            areg   <= 16'd0;
            breg   <= 32'd0;
            yout_r <= 32'd0;
            done_r <= 1'b0;
        end else begin
            case(state)
                IDLE: begin
                    done_r <= 1'b0;
                    // Hold registers
                    areg   <= areg;
                    breg   <= breg;
                    yout_r <= yout_r;
                end

                LOAD: begin
                    areg   <= ain;
                    breg   <= {16'd0, bin};
                    yout_r <= 32'd0;
                    done_r <= 1'b0;
                end

                MULTIPLY: begin
                    // If LSB of areg is set, add breg to yout_r
                    if (areg[0])
                        yout_r <= yout_r + breg;
                    else
                        yout_r <= yout_r;

                    // Shift multiplicand right, multiplier left
                    areg <= areg >> 1;
                    breg <= breg << 1;

                    done_r <= 1'b0;
                end

                DONE: begin
                    done_r <= 1'b1;
                    // Hold registers stable
                    areg   <= areg;
                    breg   <= breg;
                    yout_r <= yout_r;
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