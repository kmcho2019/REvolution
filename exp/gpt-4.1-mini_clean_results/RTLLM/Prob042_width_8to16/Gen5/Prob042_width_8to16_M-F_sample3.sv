module width_8to16 (
    input           clk,
    input           rst_n,
    input           valid_in,
    input  [7:0]    data_in,
    output reg      valid_out,
    output reg [15:0] data_out
);

    // FSM State encoding
    localparam WAIT_FIRST  = 2'd0;
    localparam WAIT_SECOND = 2'd1;

    reg [1:0] state, next_state;

    // Register to hold first byte
    reg [7:0] data_lock;

    // Signals for outputs in next cycle
    reg       valid_out_next;
    reg [15:0] data_out_next;

    // Combinational next state and output logic
    always @(*) begin
        // Defaults
        next_state      = state;
        valid_out_next  = 1'b0;
        data_out_next   = data_out; // hold current output by default

        case (state)
            WAIT_FIRST: begin
                if (valid_in) begin
                    // First byte received; store it, no output yet
                    next_state = WAIT_SECOND;
                    // No output this cycle
                    valid_out_next = 1'b0;
                end
            end

            WAIT_SECOND: begin
                if (valid_in) begin
                    // Second byte received; concatenate and assert valid output next cycle
                    next_state = WAIT_FIRST;
                    valid_out_next = 1'b1;
                    data_out_next  = {data_lock, data_in}; // First byte high, second byte low
                end
            end

            default: begin
                next_state     = WAIT_FIRST;
                valid_out_next = 1'b0;
                data_out_next  = data_out;
            end
        endcase
    end

    // Sequential logic: state and registers update
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state      <= WAIT_FIRST;
            data_lock  <= 8'd0;
            valid_out  <= 1'b0;
            data_out   <= 16'd0;
        end else begin
            state <= next_state;

            case (state)
                WAIT_FIRST: begin
                    if (valid_in) begin
                        data_lock <= data_in; // latch first byte
                    end
                end
                WAIT_SECOND: begin
                    // Hold data_lock until next WAIT_FIRST
                    // No change on data_lock
                end
            endcase

            // Update outputs synchronously
            valid_out <= valid_out_next;
            data_out  <= data_out_next;
        end
    end

endmodule