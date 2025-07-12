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

    reg         state, next_state;
    reg [7:0]   stored_byte;
    reg [15:0]  next_data_out;
    reg         next_valid_out;

    // FSM state transition
    always @(*) begin
        next_state = state;
        next_valid_out = 1'b0;
        next_data_out = data_out;

        case (state)
            WAIT_FIRST: begin
                if (valid_in) begin
                    next_state = WAIT_SECOND;
                    // no output yet, store first byte only
                end
            end
            WAIT_SECOND: begin
                if (valid_in) begin
                    next_state = WAIT_FIRST;
                    // on second valid input, prepare output for next cycle
                    next_valid_out = 1'b1;
                    next_data_out = {stored_byte, data_in};
                end
            end
        endcase
    end

    // Sequential logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state       <= WAIT_FIRST;
            stored_byte <= 8'd0;
            data_out    <= 16'd0;
            valid_out   <= 1'b0;
        end else begin
            state <= next_state;
            valid_out <= next_valid_out;
            data_out  <= next_data_out;

            // store first byte only when transitioning to WAIT_SECOND state with valid_in
            if (state == WAIT_FIRST && valid_in) begin
                stored_byte <= data_in;
            end
            // else stored_byte remains unchanged
        end
    end

endmodule