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
    reg [9:0] accumulator, next_accum;
    wire final_cycle;

    // Combinational logic
    assign final_cycle = (state == ACCUM_3) && valid_in;

    always_comb begin
        // Default assignments
        next_state = state;
        next_accum = accumulator;
        valid_out = 1'b0;

        if (valid_in) begin
            case (state)
                IDLE: begin
                    next_state = ACCUM_1;
                    next_accum = data_in;
                end
                ACCUM_1: begin
                    next_state = ACCUM_2;
                    next_accum = accumulator + data_in;
                end
                ACCUM_2: begin
                    next_state = ACCUM_3;
                    next_accum = accumulator + data_in;
                end
                ACCUM_3: begin
                    next_state = IDLE;
                    next_accum = 10'b0;
                    valid_out = 1'b1;
                end
            endcase
        end
    end

    // Sequential logic
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
            accumulator <= 10'b0;
            data_out <= 10'b0;
        end else begin
            state <= next_state;
            accumulator <= next_accum;
            
            // Only update data_out on final cycle
            if (final_cycle) begin
                data_out <= accumulator + data_in;
            end
        end
    end

endmodule