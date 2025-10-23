module multi_16bit (
    input          clk,
    input          rst_n,   // active low synchronous reset
    input          start,
    input  [15:0]  ain,
    input  [15:0]  bin,
    output reg [31:0] yout,
    output reg         done
);

    // State definitions
    typedef enum logic [1:0] {
        IDLE = 2'b00,
        LOAD = 2'b01,
        CALC = 2'b10,
        DONE = 2'b11
    } state_t;

    state_t state, next_state;

    reg [4:0] i;            // shift counter 0..16
    reg [15:0] areg;
    reg [31:0] breg;
    reg [31:0] yout_r;

    wire add_en = (state == CALC) && areg[0];
    wire [31:0] add_res = yout_r + breg;

    // FSM sequential logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
            i <= 5'd0;
            areg <= 16'd0;
            breg <= 32'd0;
            yout_r <= 32'd0;
            yout <= 32'd0;
            done <= 1'b0;
        end else begin
            state <= next_state;

            case(state)
                IDLE: begin
                    i <= 5'd0;
                    areg <= 16'd0;
                    breg <= 32'd0;
                    yout_r <= 32'd0;
                    yout <= 32'd0;
                    done <= 1'b0;
                end
                LOAD: begin
                    // Load multiplicand and multiplier
                    areg <= ain;
                    breg <= {16'd0, bin}; // zero-extend multiplier
                    yout_r <= 32'd0;
                    i <= 5'd0;
                    done <= 1'b0;
                end
                CALC: begin
                    // Shift and accumulate
                    if (add_en)
                        yout_r <= add_res;
                    else
                        yout_r <= yout_r;

                    areg <= areg >> 1;
                    breg <= breg << 1;

                    // Increment shift counter
                    if (i < 5'd16)
                        i <= i + 5'd1;
                    else
                        i <= i;
                end
                DONE: begin
                    yout <= yout_r;
                    done <= 1'b1;
                    // hold registers stable
                    areg <= areg;
                    breg <= breg;
                    yout_r <= yout_r;
                    i <= i;
                end
            endcase
        end
    end

    // FSM combinational next state logic
    always @(*) begin
        case(state)
            IDLE: begin
                if (start)
                    next_state = LOAD;
                else
                    next_state = IDLE;
            end
            LOAD: begin
                // Next cycle start calculation
                next_state = CALC;
            end
            CALC: begin
                if (i == 5'd16)
                    next_state = DONE;
                else
                    next_state = CALC;
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

endmodule