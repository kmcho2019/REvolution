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
    reg [9:0] accum_reg;
    wire [9:0] sum_result;
    wire is_last_cycle;

    // Adder pipeline register
    reg [9:0] adder_reg;

    // Combinational logic
    assign sum_result = adder_reg + data_in;
    assign is_last_cycle = (state == ACCUM_3) && valid_in;

    always_comb begin
        // Default assignments
        next_state = state;
        accum_reg = data_out;
        valid_out = 1'b0;

        if (valid_in) begin
            case (state)
                IDLE: begin
                    next_state = ACCUM_1;
                    accum_reg = {2'b00, data_in};  // Zero-extend to 10 bits
                end
                ACCUM_1: begin
                    next_state = ACCUM_2;
                    accum_reg = sum_result;
                end
                ACCUM_2: begin
                    next_state = ACCUM_3;
                    accum_reg = sum_result;
                end
                ACCUM_3: begin
                    next_state = IDLE;
                    accum_reg = sum_result;
                    valid_out = 1'b1;
                end
            endcase
        end
    end

    // Sequential logic
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
            data_out <= 10'b0;
            adder_reg <= 10'b0;
        end else begin
            state <= next_state;
            data_out <= accum_reg;
            // Pipeline register update
            if (valid_in && (state != IDLE)) begin
                adder_reg <= accum_reg;
            end else begin
                adder_reg <= 10'b0;
            end
        end
    end

endmodule