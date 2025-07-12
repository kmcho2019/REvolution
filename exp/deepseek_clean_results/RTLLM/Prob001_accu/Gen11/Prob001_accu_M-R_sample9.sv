module accu (
    input clk,
    input rst_n,
    input [7:0] data_in,
    input valid_in,
    output reg valid_out,
    output reg [9:0] data_out
);

    // States
    typedef enum logic [1:0] {
        IDLE,
        ACCUM_1,
        ACCUM_2,
        ACCUM_3
    } state_t;

    reg [1:0] state, next_state;
    reg [9:0] next_sum;
    reg next_valid_out;

    // State transition and output logic
    always_comb begin
        next_state = state;
        next_sum = data_out;
        next_valid_out = 1'b0;

        if (valid_in) begin
            case (state)
                IDLE: begin
                    next_state = ACCUM_1;
                    next_sum = data_in;
                end
                ACCUM_1: begin
                    next_state = ACCUM_2;
                    next_sum = data_out + data_in;
                end
                ACCUM_2: begin
                    next_state = ACCUM_3;
                    next_sum = data_out + data_in;
                end
                ACCUM_3: begin
                    next_state = IDLE;
                    next_sum = data_out + data_in;
                    next_valid_out = 1'b1;
                end
            endcase
        end
    end

    // Sequential logic
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
            data_out <= 10'b0;
            valid_out <= 1'b0;
        end else begin
            state <= next_state;
            data_out <= next_sum;
            valid_out <= next_valid_out;
        end
    end

endmodule