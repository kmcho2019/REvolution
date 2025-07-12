module width_8to16 (
    input           clk,
    input           rst_n,
    input           valid_in,
    input   [7:0]   data_in,
    output reg      valid_out,
    output reg [15:0] data_out
);

    typedef enum logic [0:0] {
        IDLE = 1'b0,
        WAIT = 1'b1
    } state_t;

    state_t state, next_state;

    reg [7:0] data_lock;
    reg [15:0] data_out_next;
    reg valid_out_next;

    // State register
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
        end else begin
            state <= next_state;
        end
    end

    // State transition and data capture
    always @(*) begin
        // Defaults
        next_state = state;
        valid_out_next = 1'b0;
        data_out_next = 16'd0;

        case (state)
            IDLE: begin
                if (valid_in) begin
                    next_state = WAIT;
                end
            end
            WAIT: begin
                if (valid_in) begin
                    next_state = IDLE;
                    valid_out_next = 1'b1;
                end
            end
        endcase
    end

    // Data lock and output registers
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            data_lock     <= 8'd0;
            data_out      <= 16'd0;
            valid_out     <= 1'b0;
        end else begin
            valid_out <= valid_out_next;

            case (state)
                IDLE: begin
                    if (valid_in) begin
                        data_lock <= data_in;
                    end
                end
                WAIT: begin
                    if (valid_in) begin
                        data_out <= {data_lock, data_in};
                    end
                end
            endcase
        end
    end

endmodule