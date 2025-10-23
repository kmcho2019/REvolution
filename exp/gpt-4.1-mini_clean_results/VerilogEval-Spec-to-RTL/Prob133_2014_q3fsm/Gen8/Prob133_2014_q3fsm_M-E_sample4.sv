module TopModule (
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

    // State encoding
    typedef enum logic [1:0] {
        IDLE = 2'b00,
        COUNTING = 2'b01,
        OUTPUT = 2'b10
    } state_t;

    state_t state, next_state;

    reg [1:0] cycle_cnt;    // Counts number of samples collected in COUNTING
    reg [2:0] w_shift;      // Shift register holding last 3 w values

    // Popcount function: count number of ones in 3 bits
    function automatic [1:0] popcount3(input [2:0] in_bits);
        popcount3 = in_bits[0] + in_bits[1] + in_bits[2];
    endfunction

    // State transition and output logic
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            cycle_cnt <= 2'd0;
            w_shift <= 3'b000;
            z <= 1'b0;
        end else begin
            state <= next_state;
            case (state)
                IDLE: begin
                    z <= 1'b0;
                    cycle_cnt <= 2'd0;
                    w_shift <= 3'b000;
                end

                COUNTING: begin
                    // Shift in new w
                    w_shift <= {w_shift[1:0], w};
                    cycle_cnt <= cycle_cnt + 1'b1;
                    z <= 1'b0;
                end

                OUTPUT: begin
                    // Output z for one cycle, then clear it
                    // z is computed combinationally in next_state block and registered here
                    z <= (popcount3(w_shift) == 2);
                    cycle_cnt <= 2'd0;
                end

                default: begin
                    z <= 1'b0;
                    cycle_cnt <= 2'd0;
                    w_shift <= 3'b000;
                end
            endcase
        end
    end

    // Next state combinational logic
    always @(*) begin
        case (state)
            IDLE: begin
                if (s)
                    next_state = COUNTING;
                else
                    next_state = IDLE;
            end

            COUNTING: begin
                if (cycle_cnt == 2)  // We have shifted in 3 samples (count starts from 0)
                    next_state = OUTPUT;
                else
                    next_state = COUNTING;
            end

            OUTPUT: begin
                next_state = COUNTING; // After output cycle, restart counting next 3 w cycles
            end

            default: next_state = IDLE;
        endcase
    end

endmodule