module width_8to16 (
    input          clk,
    input          rst_n,
    input          valid_in,
    input  [7:0]   data_in,
    output reg     valid_out,
    output reg [15:0] data_out
);

    // State encoding
    typedef enum logic [0:0] {
        IDLE = 1'b0,
        FULL = 1'b1
    } state_t;

    reg [7:0]   data_lock;
    reg         valid_in_d1;    // Delayed valid_in for pipeline timing
    reg [7:0]   data_in_d1;     // Delayed data_in for pipeline timing
    reg state_t  state, next_state;

    // Register state and pipeline input signals
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state      <= IDLE;
            data_lock  <= 8'b0;
            valid_in_d1 <= 1'b0;
            data_in_d1  <= 8'b0;
            valid_out  <= 1'b0;
            data_out   <= 16'b0;
        end else begin
            state <= next_state;

            // Pipeline inputs
            valid_in_d1 <= valid_in;
            data_in_d1  <= data_in;

            // Output logic: valid_out and data_out update one cycle after second input
            if (state == FULL && valid_in_d1) begin
                // valid_in_d1 here means this cycle is after second byte arrival
                data_out  <= {data_lock, data_in_d1};
                valid_out <= 1'b1;
            end else begin
                valid_out <= 1'b0;
                data_out  <= 16'b0;
            end

            // Capture first input byte when in IDLE
            if (state == IDLE && valid_in) begin
                data_lock <= data_in;
            end
        end
    end

    // Next state logic
    always @(*) begin
        next_state = state;
        case(state)
            IDLE: begin
                if (valid_in)
                    next_state = FULL;
            end
            FULL: begin
                if (valid_in)
                    next_state = IDLE; // After second byte received and output generated, back to IDLE
            end
        endcase
    end

endmodule