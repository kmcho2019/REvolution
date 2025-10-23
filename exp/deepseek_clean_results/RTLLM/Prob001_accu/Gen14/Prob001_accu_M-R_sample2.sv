module accu (
    input clk,
    input rst_n,
    input [7:0] data_in,
    input valid_in,
    output reg valid_out,
    output [9:0] data_out
);

    // State machine states
    typedef enum logic [1:0] {
        IDLE,
        ACCUM_1,
        ACCUM_2,
        ACCUM_3
    } state_t;

    reg [1:0] state, next_state;
    reg [9:0] accum_reg;
    reg [9:0] sum_reg;
    reg [1:0] count;

    // State machine sequential logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
            accum_reg <= 10'b0;
            sum_reg <= 10'b0;
            valid_out <= 1'b0;
        end else begin
            state <= next_state;
            valid_out <= (state == ACCUM_3) && valid_in;
            
            // Pipeline stage for accumulator
            if (valid_in) begin
                case (state)
                    IDLE:    accum_reg <= data_in;
                    ACCUM_1: accum_reg <= accum_reg + data_in;
                    ACCUM_2: accum_reg <= accum_reg + data_in;
                    ACCUM_3: begin
                        sum_reg <= accum_reg + data_in;
                        accum_reg <= 10'b0;
                    end
                endcase
            end
        end
    end

    // Next state logic
    always @(*) begin
        next_state = state;
        if (valid_in) begin
            case (state)
                IDLE:    next_state = ACCUM_1;
                ACCUM_1: next_state = ACCUM_2;
                ACCUM_2: next_state = ACCUM_3;
                ACCUM_3: next_state = IDLE;
            endcase
        end
    end

    // Output assignment
    assign data_out = sum_reg;

endmodule