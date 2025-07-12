module width_8to16 (
    input             clk,
    input             rst_n,
    input             valid_in,
    input      [7:0]  data_in,
    output reg        valid_out,
    output reg [15:0] data_out
);

    // State encoding
    typedef enum logic [0:0] {
        IDLE        = 1'b0,
        STORE_FIRST = 1'b1
    } state_t;

    state_t state, state_next;
    reg [7:0] data_lock;

    // Output signals with one cycle delay
    reg        valid_out_next;
    reg [15:0] data_out_next;

    // Next state and output logic (combinational)
    always @(*) begin
        // Defaults
        state_next      = state;
        data_lock       = data_lock;       // Will be overridden if latched
        valid_out_next  = 1'b0;             // Default output valid low
        data_out_next   = data_out_next;    // Hold previous output unless updated

        case(state)
            IDLE: begin
                if (valid_in) begin
                    // Latch first byte and move to STORE_FIRST
                    data_lock    = data_in;
                    state_next   = STORE_FIRST;
                    // No output yet
                    valid_out_next = 1'b0;
                end
            end

            STORE_FIRST: begin
                if (valid_in) begin
                    // Concatenate stored high bits and current low bits
                    data_out_next  = {data_lock, data_in};
                    valid_out_next = 1'b1;
                    state_next     = IDLE;
                end else begin
                    // Wait for next valid_in
                    // Keep data_lock unchanged
                    valid_out_next = 1'b0;
                end
            end

            default: begin
                state_next = IDLE;
                valid_out_next = 1'b0;
            end
        endcase
    end

    // Sequential logic: state update, data_lock latch, output registers update
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state          <= IDLE;
            data_lock      <= 8'd0;
            data_out       <= 16'd0;
            valid_out      <= 1'b0;
            data_out_next  <= 16'd0;
            valid_out_next <= 1'b0;
        end else begin
            state     <= state_next;

            // Latch first input only on transition from IDLE when valid_in
            if (state == IDLE && valid_in)
                data_lock <= data_in;
            else
                data_lock <= data_lock; // Hold data_lock

            // Update outputs registers from next signals
            valid_out  <= valid_out_next;
            data_out   <= data_out_next;

            // Clear data_out_next if no valid second input this cycle
            if (!(state == STORE_FIRST && valid_in))
                data_out_next <= data_out_next; // Hold last output or could clear if desired
            else
                data_out_next <= data_out_next; // Assigned combinationally already
        end
    end

endmodule