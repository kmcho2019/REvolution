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
    localparam ACCUM = 2'b01;
    localparam OUTPUT = 2'b10;

    reg [1:0] state, next_state;
    reg [1:0] count;
    reg [9:0] sum_reg;
    wire [9:0] next_sum;

    // Combinational addition
    assign next_sum = sum_reg + data_in;

    // State transition logic
    always @(*) begin
        next_state = state;
        case (state)
            IDLE: if (valid_in) next_state = ACCUM;
            ACCUM: begin
                if (count == 2'b11 && valid_in)
                    next_state = OUTPUT;
                else if (!valid_in)
                    next_state = IDLE;
            end
            OUTPUT: next_state = IDLE;
        endcase
    end

    // Sequential logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
            count <= 2'b00;
            sum_reg <= 10'b0;
            data_out <= 10'b0;
            valid_out <= 1'b0;
        end
        else begin
            state <= next_state;
            valid_out <= 1'b0;

            case (next_state)
                IDLE: begin
                    count <= 2'b00;
                    sum_reg <= 10'b0;
                end
                ACCUM: if (valid_in) begin
                    sum_reg <= next_sum;
                    count <= count + 1'b1;
                end
                OUTPUT: begin
                    data_out <= next_sum;
                    valid_out <= 1'b1;
                end
            endcase
        end
    end

endmodule