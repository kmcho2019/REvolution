module width_8to16 (
    input             clk,
    input             rst_n,
    input             valid_in,
    input      [7:0]  data_in,
    output reg        valid_out,
    output reg [15:0] data_out
);

    // FSM states
    localparam IDLE        = 1'b0;
    localparam WAIT_SECOND = 1'b1;

    reg state, state_next;

    reg [7:0]  data_lock;       // holds first byte
    reg [15:0] output_latch;    // holds combined output
    reg        output_ready;    // indicates output_latch valid to output

    // FSM next state logic
    always @(*) begin
        case(state)
            IDLE: begin
                if (valid_in)
                    state_next = WAIT_SECOND;
                else
                    state_next = IDLE;
            end
            WAIT_SECOND: begin
                if (valid_in)
                    state_next = IDLE;
                else
                    state_next = WAIT_SECOND;
            end
            default: state_next = IDLE;
        endcase
    end

    // Sequential logic: state update, input latching, output generation
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state        <= IDLE;
            data_lock    <= 8'd0;
            output_latch <= 16'd0;
            output_ready <= 1'b0;
            data_out     <= 16'd0;
            valid_out    <= 1'b0;
        end else begin
            state <= state_next;

            // Default: valid_out low unless output_ready asserted this cycle
            valid_out <= 1'b0;

            // Output generation stage:
            // If output_ready was asserted in previous cycle, output data_out and valid_out this cycle
            if (output_ready) begin
                data_out  <= output_latch;
                valid_out <= 1'b1;
                output_ready <= 1'b0; // clear flag after outputting once
            end

            // FSM behavior and input capture
            case(state_next)
                IDLE: begin
                    if (valid_in) begin
                        // Capture first byte when entering WAIT_SECOND
                        data_lock <= data_in;
                    end
                    // else no change to data_lock
                end

                WAIT_SECOND: begin
                    if (valid_in) begin
                        // On second valid input: concatenate and mark output ready for next cycle
                        output_latch  <= {data_lock, data_in}; // first byte high bits
                        output_ready  <= 1'b1;
                        // data_lock will be overwritten on next first byte capture (in IDLE state)
                    end
                    // else remain waiting for second valid input
                end
            endcase
        end
    end

endmodule