module accu (
    input clk,
    input rst_n,
    input [7:0] data_in,
    input valid_in,
    output reg valid_out,
    output reg [9:0] data_out
);

    // State definitions
    typedef enum logic [1:0] {
        IDLE,
        ACCUM_1,
        ACCUM_2,
        ACCUM_3
    } state_t;

    reg [1:0] state, next_state;
    reg [1:0] counter;  // Tracks 0-3 counts
    reg [9:0] next_data;
    reg next_valid_out;

    // Combinational logic for next state and outputs
    always_comb begin
        // Default assignments
        next_state = state;
        next_data = data_out;
        next_valid_out = 1'b0;
        counter = 2'b00;  // Default, will be overridden

        if (valid_in) begin
            case (state)
                IDLE: begin
                    next_state = ACCUM_1;
                    next_data = data_in;
                    counter = 2'b01;
                end
                ACCUM_1: begin
                    next_state = ACCUM_2;
                    next_data = data_out + data_in;
                    counter = 2'b10;
                end
                ACCUM_2: begin
                    next_state = ACCUM_3;
                    next_data = data_out + data_in;
                    counter = 2'b11;
                end
                ACCUM_3: begin
                    next_state = IDLE;
                    next_data = data_out + data_in;
                    next_valid_out = 1'b1;
                    counter = 2'b00;
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
            data_out <= next_data;
            valid_out <= next_valid_out;
        end
    end

endmodule