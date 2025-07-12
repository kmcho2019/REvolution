module width_8to16 (
    input            clk,
    input            rst_n,
    input            valid_in,
    input      [7:0] data_in,
    output reg       valid_out,
    output reg [15:0] data_out
);

    // FSM states
    localparam IDLE        = 1'b0;
    localparam WAIT_SECOND = 1'b1;

    reg state, next_state;

    reg [7:0] data_lock;       // store first byte
    reg [15:0] next_data_out;  // register for next output data
    reg next_valid_out;        // register for next valid_out

    // FSM state update
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            state <= IDLE;
        else
            state <= next_state;
    end

    // FSM next state logic and data capture
    always @(*) begin
        // Defaults
        next_state = state;
        next_data_out = data_out;
        next_valid_out = 1'b0;

        case (state)
            IDLE: begin
                if (valid_in) begin
                    // Capture first byte, go to wait second byte
                    next_state = WAIT_SECOND;
                    // no output yet
                end
            end

            WAIT_SECOND: begin
                if (valid_in) begin
                    // On second byte, form 16-bit data and output next cycle
                    next_data_out = {data_lock, data_in};
                    next_valid_out = 1'b1;
                    next_state = IDLE;
                end
            end

            default: next_state = IDLE;
        endcase
    end

    // Data register and output valid register logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            data_out   <= 16'd0;
            valid_out  <= 1'b0;
            data_lock  <= 8'd0;
        end else begin
            valid_out <= next_valid_out;

            if (state == IDLE && valid_in) begin
                // Store first byte when in IDLE and valid input
                data_lock <= data_in;
            end

            if (next_valid_out) begin
                data_out <= next_data_out;
            end else if (!valid_out) begin
                // Optional: clear data_out when no valid output
                data_out <= 16'd0;
            end
        end
    end

endmodule