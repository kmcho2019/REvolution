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

    reg [7:0]  data_lock;        // stores first received byte
    reg [15:0] output_latch;     // holds concatenated output data (ready to be output next cycle)
    reg        pending_valid;    // flag indicating output_latch has valid data to output next cycle

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
            state         <= IDLE;
            data_lock     <= 8'd0;
            output_latch  <= 16'd0;
            pending_valid <= 1'b0;
            data_out      <= 16'd0;
            valid_out     <= 1'b0;
        end else begin
            state <= state_next;

            // Default outputs: valid_out low unless pending_valid indicates output
            valid_out <= 1'b0;

            // FSM behavior
            case(state)
                IDLE: begin
                    // Wait for first valid input
                    if (valid_in) begin
                        data_lock <= data_in;  // latch first byte
                    end
                    // pending_valid unchanged here
                end

                WAIT_SECOND: begin
                    if (valid_in) begin
                        // On second valid input: prepare output_latch and mark output pending
                        output_latch  <= {data_lock, data_in}; // first byte high, second low
                        pending_valid <= 1'b1;
                    end
                    // else wait in this state
                end
            endcase

            // Output generation: valid_out and data_out asserted one cycle after pending_valid set
            if (pending_valid) begin
                data_out      <= output_latch;
                valid_out     <= 1'b1;
                pending_valid <= 1'b0; // clear after output asserted
            end
        end
    end

endmodule