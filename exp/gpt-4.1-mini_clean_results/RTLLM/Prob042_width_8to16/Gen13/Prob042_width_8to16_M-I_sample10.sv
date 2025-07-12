module width_8to16 (
    input           clk,
    input           rst_n,
    input           valid_in,
    input   [7:0]   data_in,
    output reg      valid_out,
    output reg [15:0] data_out
);

    // State encoding
    typedef enum logic [0:0] {
        IDLE      = 1'b0,
        GOT_FIRST = 1'b1
    } state_t;

    state_t state, next_state;

    reg [7:0] data_lock;         // Hold first byte
    reg [15:0] data_concat;      // Concatenated data after second byte
    reg        data_ready;       // Valid flag for data_concat

    // State and registers update
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state       <= IDLE;
            data_lock   <= 8'd0;
            data_concat <= 16'd0;
            data_ready  <= 1'b0;
            valid_out   <= 1'b0;
            data_out    <= 16'd0;
        end else begin
            // Default output valid low, unless data_ready set
            valid_out <= data_ready;
            if (data_ready)
                data_out <= data_concat;

            state <= next_state;

            data_ready <= 1'b0; // Clear data_ready after latching output

            case (state)
                IDLE: begin
                    if (valid_in) begin
                        data_lock <= data_in; // Store first byte
                    end
                end
                GOT_FIRST: begin
                    if (valid_in) begin
                        // Concatenate first and second bytes
                        data_concat <= {data_lock, data_in};
                        data_ready  <= 1'b1; // Signal valid output next cycle
                    end
                end
            endcase
        end
    end

    // Next state logic combinational
    always @(*) begin
        case (state)
            IDLE: begin
                if (valid_in)
                    next_state = GOT_FIRST;
                else
                    next_state = IDLE;
            end
            GOT_FIRST: begin
                if (valid_in)
                    next_state = IDLE;  // After second byte processed, return to IDLE
                else
                    next_state = GOT_FIRST;
            end
            default: next_state = IDLE;
        endcase
    end

endmodule