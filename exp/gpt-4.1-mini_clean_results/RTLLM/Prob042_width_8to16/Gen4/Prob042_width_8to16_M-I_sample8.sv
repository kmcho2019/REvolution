module width_8to16 (
    input             clk,
    input             rst_n,
    input             valid_in,
    input      [7:0]  data_in,
    output reg        valid_out,
    output reg [15:0] data_out
);

    // FSM states
    typedef enum logic [1:0] {
        WAIT_FIRST  = 2'b00,
        WAIT_SECOND = 2'b01,
        OUTPUT      = 2'b10
    } state_t;

    state_t state, next_state;

    reg [7:0]  data_lock;       // stores first 8-bit data
    reg [15:0] data_out_next;   // holds concatenated data before output
    reg        valid_out_next;  // valid signal delayed by one cycle

    // State register update
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state          <= WAIT_FIRST;
            data_lock      <= 8'd0;
            data_out       <= 16'd0;
            valid_out      <= 1'b0;
            data_out_next  <= 16'd0;
            valid_out_next <= 1'b0;
        end else begin
            state     <= next_state;
            valid_out <= valid_out_next;
            data_out  <= data_out_next;

            case (state)
                WAIT_FIRST: begin
                    valid_out_next <= 1'b0;
                    if (valid_in) begin
                        data_lock      <= data_in;
                    end
                end

                WAIT_SECOND: begin
                    valid_out_next <= 1'b0;
                    // data_lock remains unchanged until output stage
                end

                OUTPUT: begin
                    // Output valid_out for 1 cycle; valid_out_next assigned below
                    valid_out_next <= 1'b0; // Deassert next cycle by default
                end
            endcase
        end
    end

    // Next state and combinational logic
    always @(*) begin
        // Default assignments
        next_state      = state;
        data_out_next   = data_out;
        valid_out_next  = 1'b0;

        case (state)
            WAIT_FIRST: begin
                if (valid_in) begin
                    next_state = WAIT_SECOND;
                end
            end

            WAIT_SECOND: begin
                if (valid_in) begin
                    data_out_next  = {data_lock, data_in};
                    valid_out_next = 1'b1; // Will be registered next cycle
                    next_state     = OUTPUT;
                end
            end

            OUTPUT: begin
                // valid_out and data_out have been updated last cycle
                // Now go back to waiting first input
                next_state = WAIT_FIRST;
            end

            default: next_state = WAIT_FIRST;
        endcase
    end

endmodule