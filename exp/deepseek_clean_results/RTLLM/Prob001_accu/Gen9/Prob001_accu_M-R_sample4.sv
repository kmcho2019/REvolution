module accu (
    input clk,
    input rst_n,
    input [7:0] data_in,
    input valid_in,
    output reg valid_out,
    output reg [9:0] data_out
);

    // State parameters
    parameter IDLE = 2'b00;
    parameter ACCUM_1 = 2'b01;
    parameter ACCUM_2 = 2'b10;
    parameter ACCUM_3 = 2'b11;

    reg [1:0] state, next_state;
    reg [9:0] accum_reg;
    wire [9:0] next_accum;

    // Next state and accumulation logic
    always @(*) begin
        next_state = state;
        next_accum = accum_reg;
        valid_out = 1'b0;
        data_out = 10'b0;

        if (valid_in) begin
            case (state)
                IDLE: begin
                    next_state = ACCUM_1;
                    next_accum = data_in;
                end
                ACCUM_1: begin
                    next_state = ACCUM_2;
                    next_accum = accum_reg + data_in;
                end
                ACCUM_2: begin
                    next_state = ACCUM_3;
                    next_accum = accum_reg + data_in;
                end
                ACCUM_3: begin
                    next_state = IDLE;
                    next_accum = 10'b0;
                    data_out = accum_reg + data_in;
                    valid_out = 1'b1;
                end
            endcase
        end
    end

    // Sequential logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
            accum_reg <= 10'b0;
        end
        else begin
            state <= next_state;
            accum_reg <= next_accum;
        end
    end

endmodule