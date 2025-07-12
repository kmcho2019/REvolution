module width_8to16 (
    input           clk,
    input           rst_n,
    input           valid_in,
    input   [7:0]   data_in,
    output reg      valid_out,
    output reg [15:0] data_out
);

    // FSM states
    localparam WAIT_FIRST  = 1'b0;
    localparam WAIT_SECOND = 1'b1;

    reg state, next_state;
    reg [7:0] data_lock;         // To hold first 8-bit data
    reg [15:0] data_out_next;    // Next cycle data output
    reg        valid_out_next;   // Next cycle valid output

    // FSM state register
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state          <= WAIT_FIRST;
            data_lock      <= 8'b0;
            data_out       <= 16'b0;
            valid_out      <= 1'b0;
        end else begin
            state     <= next_state;
            valid_out <= valid_out_next;
            data_out  <= data_out_next;

            // Store first input data when in WAIT_FIRST and valid_in asserted
            if (state == WAIT_FIRST && valid_in) begin
                data_lock <= data_in;
            end
        end
    end

    // Next state and output logic combinational block
    always @(*) begin
        // Default assignments
        next_state      = state;
        valid_out_next  = 1'b0;
        data_out_next   = 16'b0;

        case (state)
            WAIT_FIRST: begin
                if (valid_in) begin
                    // First valid data received, move to wait second data
                    next_state = WAIT_SECOND;
                end
                // No output yet since only one data input collected
            end

            WAIT_SECOND: begin
                if (valid_in) begin
                    // On second valid input, prepare output and go back to WAIT_FIRST
                    data_out_next  = {data_lock, data_in};
                    valid_out_next = 1'b1;
                    next_state     = WAIT_FIRST;
                end else begin
                    // Still waiting for second valid input
                    next_state = WAIT_SECOND;
                end
            end
        endcase
    end

endmodule