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

    reg [7:0]  data_lock;        // Stores first byte
    reg [15:0] data_concat;      // Holds concatenated data when second byte arrives
    reg        valid_concat;     // Flag indicating data_concat is valid

    // Sequential logic: state, data registers, output registers
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state        <= IDLE;
            data_lock    <= 8'd0;
            data_concat  <= 16'd0;
            valid_concat <= 1'b0;

            valid_out    <= 1'b0;
            data_out     <= 16'd0;
        end else begin
            state <= next_state;

            // Default clear concatenated valid flag unless set below
            valid_concat <= 1'b0;

            case(state)
                IDLE: begin
                    if (valid_in) begin
                        data_lock <= data_in;  // Store first byte
                    end
                end
                GOT_FIRST: begin
                    if (valid_in) begin
                        // On second byte, form 16-bit concatenated data: first byte high, second byte low
                        data_concat  <= {data_lock, data_in};
                        valid_concat <= 1'b1;  // Mark concatenated data as valid this cycle
                    end
                end
            endcase

            // Register output signals delayed by one cycle from valid_concat and data_concat
            valid_out <= valid_concat;
            if (valid_concat)
                data_out <= data_concat;
        end
    end

    // Next-state combinational logic
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
                    next_state = IDLE;  // After second byte, go back to IDLE
                else
                    next_state = GOT_FIRST;
            end
            default: next_state = IDLE;
        endcase
    end

endmodule