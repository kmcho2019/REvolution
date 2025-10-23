module width_8to16 (
    input             clk,
    input             rst_n,
    input             valid_in,
    input      [7:0]  data_in,
    output reg        valid_out,
    output reg [15:0] data_out
);

    // State encoding
    localparam IDLE          = 1'b0;
    localparam WAIT_FOR_SECOND = 1'b1;

    reg state, state_next;
    reg [7:0] data_lock;

    // Registers to hold next cycle output signals
    reg valid_out_next;
    reg [15:0] data_out_next;

    // Sequential block: state and registers update
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state       <= IDLE;
            data_lock   <= 8'd0;
            valid_out   <= 1'b0;
            data_out    <= 16'd0;
        end else begin
            state       <= state_next;
            data_lock   <= (state == IDLE && valid_in) ? data_in : data_lock;
            valid_out   <= valid_out_next;
            data_out    <= data_out_next;
        end
    end

    // Combinational logic: determine next state and outputs
    always @(*) begin
        // Defaults
        state_next       = state;
        valid_out_next   = 1'b0;
        data_out_next    = 16'd0;

        case(state)
            IDLE: begin
                if (valid_in) begin
                    // Latch first byte and wait for second
                    state_next = WAIT_FOR_SECOND;
                    valid_out_next = 1'b0;  // No output yet
                    data_out_next = 16'd0;
                end
            end
            WAIT_FOR_SECOND: begin
                if (valid_in) begin
                    // Second byte arrived: output concatenated data next cycle
                    state_next = IDLE;
                    valid_out_next = 1'b1;
                    data_out_next = {data_lock, data_in};
                end else begin
                    // Wait for next valid_in
                    state_next = WAIT_FOR_SECOND;
                    valid_out_next = 1'b0;
                    data_out_next = 16'd0;
                end
            end
            default: begin
                state_next = IDLE;
                valid_out_next = 1'b0;
                data_out_next = 16'd0;
            end
        endcase
    end

endmodule