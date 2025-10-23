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
    reg [7:0] data_lock;          // Store first 8-bit data
    reg [7:0] data_second;        // Store second 8-bit data (for clarity)
    reg       valid_out_next;
    reg [15:0] data_out_next;

    // Sequential logic: State, data storage, outputs update
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state       <= WAIT_FIRST;
            data_lock   <= 8'd0;
            data_second <= 8'd0;
            data_out    <= 16'd0;
            valid_out   <= 1'b0;
        end else begin
            state     <= next_state;
            valid_out <= valid_out_next;
            data_out  <= data_out_next;

            if (state == WAIT_FIRST && valid_in) begin
                // Capture first input data
                data_lock <= data_in;
            end else if (state == WAIT_SECOND && valid_in) begin
                // Capture second input data
                data_second <= data_in;
            end
        end
    end

    // Combinational logic: Next state and output generation
    always @(*) begin
        // Default assignments: maintain previous outputs by default
        next_state      = state;
        valid_out_next  = 1'b0;
        data_out_next   = data_out;  // Hold previous output if no new data

        case (state)
            WAIT_FIRST: begin
                if (valid_in) begin
                    // First valid input received, move to wait for second input
                    next_state = WAIT_SECOND;
                end
            end

            WAIT_SECOND: begin
                if (valid_in) begin
                    // Second valid input received, output valid next cycle and go back to WAIT_FIRST
                    next_state     = WAIT_FIRST;
                    valid_out_next = 1'b1;
                    data_out_next  = {data_lock, data_in};
                end
                // else remain in WAIT_SECOND waiting for valid_in
            end
        endcase
    end

endmodule