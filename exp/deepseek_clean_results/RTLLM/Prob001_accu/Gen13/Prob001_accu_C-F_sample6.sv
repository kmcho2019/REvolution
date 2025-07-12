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
    reg [9:0] next_data;
    reg next_valid_out;
    reg accum_en;  // Accumulator enable for power gating

    // State transition and output logic
    always_comb begin
        next_state = state;
        next_data = data_out;
        next_valid_out = 1'b0;
        accum_en = 1'b0;

        if (valid_in) begin
            accum_en = 1'b1;  // Enable accumulator only when needed
            
            case (state)
                IDLE: begin
                    next_state = ACCUM_1;
                    next_data = data_in;
                end
                ACCUM_1: begin
                    next_state = ACCUM_2;
                    next_data = data_out + data_in;
                end
                ACCUM_2: begin
                    next_state = ACCUM_3;
                    next_data = data_out + data_in;
                end
                ACCUM_3: begin
                    next_state = IDLE;
                    // Calculate final sum in one operation
                    next_data = data_out + data_in;
                    next_valid_out = 1'b1;
                    accum_en = 1'b0;  // Disable after final accumulation
                end
            endcase
        end
    end

    // Sequential logic with clock gating
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
            data_out <= 10'b0;
            valid_out <= 1'b0;
        end else begin
            state <= next_state;
            valid_out <= next_valid_out;
            
            // Conditional accumulator update
            if (accum_en) begin
                data_out <= next_data;
            end
        end
    end

endmodule