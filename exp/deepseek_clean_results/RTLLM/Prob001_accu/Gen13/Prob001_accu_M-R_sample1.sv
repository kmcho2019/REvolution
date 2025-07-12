module accu (
    input clk,
    input rst_n,
    input [7:0] data_in,
    input valid_in,
    output reg valid_out,
    output reg [9:0] data_out
);

    // State encoding
    localparam IDLE = 2'b00;
    localparam ACCUM_1 = 2'b01;
    localparam ACCUM_2 = 2'b10;
    localparam ACCUM_3 = 2'b11;

    reg [1:0] state, next_state;
    reg [9:0] accum_reg;
    wire [9:0] next_accum = accum_reg + data_in;

    // State transition logic
    always @(*) begin
        case (state)
            IDLE:    next_state = valid_in ? ACCUM_1 : IDLE;
            ACCUM_1: next_state = valid_in ? ACCUM_2 : ACCUM_1;
            ACCUM_2: next_state = valid_in ? ACCUM_3 : ACCUM_2;
            ACCUM_3: next_state = valid_in ? IDLE : ACCUM_3;
            default: next_state = IDLE;
        endcase
    end

    // Sequential logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
            accum_reg <= 10'b0;
            data_out <= 10'b0;
            valid_out <= 1'b0;
        end else begin
            state <= next_state;
            valid_out <= 1'b0;

            if (valid_in) begin
                case (state)
                    IDLE:    accum_reg <= data_in;
                    ACCUM_1: accum_reg <= next_accum;
                    ACCUM_2: accum_reg <= next_accum;
                    ACCUM_3: begin
                        data_out <= next_accum;
                        valid_out <= 1'b1;
                        accum_reg <= 10'b0;
                    end
                endcase
            end
        end
    end

endmodule