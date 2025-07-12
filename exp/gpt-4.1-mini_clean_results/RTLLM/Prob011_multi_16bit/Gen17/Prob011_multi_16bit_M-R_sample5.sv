module multi_16bit (
    input          clk,
    input          rst_n,
    input          start,
    input  [15:0]  ain,
    input  [15:0]  bin,
    output reg [31:0] yout,
    output reg      done
);

    // FSM states
    typedef enum reg [1:0] {IDLE=2'd0, RUN=2'd1, DONE=2'd2} state_t;
    reg [1:0] state, next_state;

    reg [15:0] areg;      // multiplicand register
    reg [15:0] breg;      // multiplier register
    reg [4:0]  i;         // shift count (0 to 16)
    reg [31:0] yout_r;    // accumulator for product

    // FSM sequential logic: state update
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            state <= IDLE;
        else
            state <= next_state;
    end

    // FSM combinational logic: next state and outputs
    always @(*) begin
        next_state = state;
        case(state)
            IDLE: if (start) next_state = RUN;
            RUN:  if (i == 5'd16) next_state = DONE;
            DONE: next_state = IDLE;
            default: next_state = IDLE;
        endcase
    end

    // Data path sequential logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            areg   <= 16'd0;
            breg   <= 16'd0;
            i      <= 5'd0;
            yout_r <= 32'd0;
            yout   <= 32'd0;
            done   <= 1'b0;
        end else begin
            case (state)
                IDLE: begin
                    done <= 1'b0;
                    i    <= 5'd0;
                    yout_r <= 32'd0;
                    if (start) begin
                        areg <= ain;
                        breg <= bin;
                    end
                end
                RUN: begin
                    // If LSB of breg is 1, add (areg shifted by i) to accumulator
                    if (breg[0])
                        yout_r <= yout_r + ( {16'd0, areg} << i );
                    else
                        yout_r <= yout_r;

                    // Shift breg right by 1 (drop LSB processed)
                    breg <= breg >> 1;

                    // Increment shift counter
                    i <= i + 5'd1;
                end
                DONE: begin
                    done <= 1'b1;
                    yout <= yout_r;  // latch final product output
                end
                default: ;
            endcase
        end
    end

endmodule