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
    localparam IDLE    = 2'd0;
    localparam RUNNING = 2'd1;
    localparam DONE_ST = 2'd2;

    reg [1:0] state, next_state;

    reg [4:0]  i;           // shift count 0 to 16
    reg [15:0] areg;        // multiplicand register (fixed)
    reg [15:0] breg;        // multiplier register (fixed)
    reg [31:0] yout_r;      // product accumulator
    reg        done_r;

    // FSM sequential state update
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            state <= IDLE;
        else
            state <= next_state;
    end

    // FSM next state logic
    always @(*) begin
        case (state)
            IDLE:    next_state = start ? RUNNING : IDLE;
            RUNNING: next_state = (i == 5'd16) ? DONE_ST : RUNNING;
            DONE_ST: next_state = (start == 1'b0) ? IDLE : DONE_ST;
            default: next_state = IDLE;
        endcase
    end

    // Shift count counter
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            i <= 5'd0;
        else if (state == RUNNING)
            i <= i + 5'd1;
        else
            i <= 5'd0;
    end

    // Registers update
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            areg   <= 16'd0;
            breg   <= 16'd0;
            yout_r <= 32'd0;
            done_r <= 1'b0;
        end else begin
            case (state)
                IDLE: begin
                    done_r <= 1'b0;
                    if (start) begin
                        areg   <= ain;
                        breg   <= bin;
                        yout_r <= 32'd0;
                    end
                end
                RUNNING: begin
                    // At each cycle i, if bit i of areg is set, accumulate (breg << i)
                    if (areg[i])
                        yout_r <= yout_r + ( {16'd0, breg} << i );
                    else
                        yout_r <= yout_r;
                end
                DONE_ST: begin
                    done_r <= 1'b1;
                end
                default: begin
                    // default hold
                    areg   <= areg;
                    breg   <= breg;
                    yout_r <= yout_r;
                    done_r <= done_r;
                end
            endcase
        end
    end

    assign yout = yout_r;
    assign done = done_r;

endmodule