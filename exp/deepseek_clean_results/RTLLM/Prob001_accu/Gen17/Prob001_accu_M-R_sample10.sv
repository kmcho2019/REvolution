module accu (
    input clk,
    input rst_n,
    input [7:0] data_in,
    input valid_in,
    output reg valid_out,
    output reg [9:0] data_out
);

    // State encoding
    typedef enum logic [2:0] {
        IDLE,
        ACCUM1,
        ACCUM2,
        ACCUM3,
        OUTPUT
    } state_t;

    state_t current_state, next_state;
    reg [9:0] accum_reg, next_accum;

    // State transition logic
    always @(*) begin
        next_state = current_state;
        next_accum = accum_reg;
        valid_out = 1'b0;

        case (current_state)
            IDLE: if (valid_in) begin
                next_state = ACCUM1;
                next_accum = data_in;
            end

            ACCUM1: if (valid_in) begin
                next_state = ACCUM2;
                next_accum = accum_reg + data_in;
            end

            ACCUM2: if (valid_in) begin
                next_state = ACCUM3;
                next_accum = accum_reg + data_in;
            end

            ACCUM3: if (valid_in) begin
                next_state = OUTPUT;
                next_accum = accum_reg + data_in;
            end

            OUTPUT: begin
                next_state = IDLE;
                valid_out = 1'b1;
                next_accum = 10'b0;
            end

            default: next_state = IDLE;
        endcase
    end

    // Sequential logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            current_state <= IDLE;
            accum_reg <= 10'b0;
            data_out <= 10'b0;
        end
        else begin
            current_state <= next_state;
            accum_reg <= next_accum;

            if (current_state == OUTPUT)
                data_out <= accum_reg;
        end
    end

endmodule