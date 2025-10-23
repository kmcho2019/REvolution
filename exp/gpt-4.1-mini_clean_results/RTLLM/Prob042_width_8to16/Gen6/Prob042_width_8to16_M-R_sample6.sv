module width_8to16 (
    input           clk,
    input           rst_n,
    input           valid_in,
    input   [7:0]   data_in,
    output reg      valid_out,
    output reg [15:0] data_out
);

    // FSM states
    typedef enum logic [0:0] {
        IDLE      = 1'b0,
        HALF_FULL = 1'b1
    } state_t;

    state_t state, next_state;

    reg [7:0] data_lock;         // holds first byte
    reg [15:0] data_out_reg;     // holds concatenated output
    reg valid_out_reg;           // output valid flag delayed by one cycle

    // State register update
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state          <= IDLE;
            data_lock      <= 8'd0;
            data_out_reg   <= 16'd0;
            valid_out_reg  <= 1'b0;
            valid_out      <= 1'b0;
            data_out       <= 16'd0;
        end else begin
            state          <= next_state;
            valid_out_reg  <= 1'b0; // default deassert

            case(state)
                IDLE: begin
                    if (valid_in) begin
                        data_lock <= data_in;   // latch first byte
                        next_state <= HALF_FULL;
                    end else begin
                        next_state <= IDLE;
                    end
                end

                HALF_FULL: begin
                    if (valid_in) begin
                        data_out_reg  <= {data_lock, data_in}; // concat first and second bytes
                        valid_out_reg <= 1'b1;                  // indicate output valid next cycle
                        next_state    <= IDLE;
                    end else begin
                        next_state <= HALF_FULL;
                    end
                end

                default: next_state <= IDLE;
            endcase

            // Update output registers (valid_out and data_out) one cycle delayed
            valid_out <= valid_out_reg;
            if (valid_out_reg)
                data_out <= data_out_reg;
        end
    end

endmodule