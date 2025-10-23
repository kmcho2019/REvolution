module width_8to16 (
    input clk,
    input rst_n,
    input valid_in,
    input [7:0] data_in,
    output reg valid_out,
    output reg [15:0] data_out
);

    typedef enum logic {IDLE, HALF} state_t;
    state_t state, next_state;

    reg [7:0] data_lock;      // To store first 8-bit input
    reg valid_out_next;
    reg [15:0] data_out_next;

    // State register
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
            data_lock <= 8'd0;
            valid_out <= 1'b0;
            data_out <= 16'd0;
        end else begin
            state <= next_state;
            valid_out <= valid_out_next;
            data_out <= data_out_next;

            // Clear next outputs by default
            valid_out_next <= 1'b0;
            data_out_next <= 16'd0;

            case (state)
                IDLE: begin
                    if (valid_in) begin
                        data_lock <= data_in; // store first input
                    end
                end
                HALF: begin
                    // no data_lock update here; waiting for second input
                end
            endcase
        end
    end

    // Next state logic and output preparation
    always @(*) begin
        // defaults
        next_state = state;
        valid_out_next = 1'b0;
        data_out_next = 16'd0;

        case (state)
            IDLE: begin
                if (valid_in) begin
                    next_state = HALF;
                end
            end

            HALF: begin
                if (valid_in) begin
                    // Second input arrived, generate output next cycle
                    valid_out_next = 1'b1;
                    data_out_next = {data_lock, data_in};
                    next_state = IDLE;
                end
            end
        endcase
    end

endmodule