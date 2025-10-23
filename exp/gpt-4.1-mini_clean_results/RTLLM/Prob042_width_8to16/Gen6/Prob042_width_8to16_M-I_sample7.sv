module width_8to16 (
    input           clk,
    input           rst_n,
    input           valid_in,
    input   [7:0]   data_in,
    output reg      valid_out,
    output reg [15:0] data_out
);

    typedef enum logic [1:0] {
        IDLE  = 2'b00,  // waiting for first valid input
        WAIT  = 2'b01,  // first valid input latched, wait for second
        OUTPUT= 2'b10   // output data ready next cycle
    } state_t;

    state_t state, next_state;

    reg [7:0] data_lock;       // holds first 8-bit input
    reg [15:0] data_out_next;  // holds concatenated output before registering
    reg valid_out_next;        // next cycle valid_out

    // State and data registers
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state        <= IDLE;
            data_lock    <= 8'd0;
            data_out     <= 16'd0;
            valid_out    <= 1'b0;
        end else begin
            state        <= next_state;
            valid_out    <= valid_out_next;

            // Update output data register only when valid_out asserted
            if (valid_out_next)
                data_out <= data_out_next;

            // Store first data if moving to WAIT state
            if (state == IDLE && next_state == WAIT && valid_in)
                data_lock <= data_in;
        end
    end

    // Next state logic and combinational outputs
    always @(*) begin
        next_state     = state;
        data_out_next  = 16'd0;
        valid_out_next = 1'b0;

        case(state)
            IDLE: begin
                if (valid_in) begin
                    next_state = WAIT;
                end
            end
            WAIT: begin
                if (valid_in) begin
                    // Second valid input arrives: form output and go to OUTPUT state
                    data_out_next  = {data_lock, data_in};
                    valid_out_next = 1'b0;    // valid_out asserted next cycle only
                    next_state     = OUTPUT;
                end
            end
            OUTPUT: begin
                // Assert valid_out this cycle with data_out updated previous cycle
                valid_out_next = 1'b1;

                // After output, go back to IDLE to accept next pair
                next_state = IDLE;
            end
            default: next_state = IDLE;
        endcase
    end

endmodule