module multi_16bit (
    input             clk,
    input             rst_n,
    input             start,
    input      [15:0] ain,
    input      [15:0] bin,
    output reg [31:0] yout,
    output reg        done
);

    // FSM states
    typedef enum logic [1:0] {
        IDLE    = 2'b00,
        RUNNING = 2'b01,
        DONE    = 2'b10
    } state_t;

    state_t state, next_state;

    reg [4:0] count;           // 0 to 16 for shifts
    reg [15:0] areg, breg;     // Captured inputs
    reg [31:0] product;        // Accumulator

    // FSM next state logic
    always @(*) begin
        case(state)
            IDLE:   next_state = start ? RUNNING : IDLE;
            RUNNING: next_state = (count == 16) ? DONE : RUNNING;
            DONE:   next_state = start ? DONE : IDLE;
            default: next_state = IDLE;
        endcase
    end

    // FSM and control registers update
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state   <= IDLE;
            count   <= 5'd0;
            areg    <= 16'd0;
            breg    <= 16'd0;
            product <= 32'd0;
            done    <= 1'b0;
            yout    <= 32'd0;
        end else begin
            state <= next_state;

            case(state)
                IDLE: begin
                    done <= 1'b0;
                    count <= 5'd0;
                    if (start) begin
                        areg <= ain;
                        breg <= bin;
                        product <= 32'd0;
                    end
                end

                RUNNING: begin
                    // At each cycle (count from 0 to 15), check multiplier bit
                    if (breg[count]) begin
                        product <= product + ( {16'd0, areg} << count );
                    end
                    count <= count + 1;
                end

                DONE: begin
                    done <= 1'b1;
                    yout <= product;
                end
            endcase
        end
    end

endmodule