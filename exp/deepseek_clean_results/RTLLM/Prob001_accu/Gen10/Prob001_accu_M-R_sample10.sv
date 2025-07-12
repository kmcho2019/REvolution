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
    reg [9:0] sum;

    // State transition logic
    always @(*) begin
        case (state)
            IDLE: next_state = valid_in ? ACCUM : IDLE;
            ACCUM: begin
                if (count == 2'b10 && valid_in)
                    next_state = OUTPUT;
                else
                    next_state = ACCUM;
            end
            OUTPUT: next_state = IDLE;
            default: next_state = IDLE;
        endcase
    end

    // Sequential logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
            count <= 2'b0;
            sum <= 10'b0;
            data_out <= 10'b0;
            valid_out <= 1'b0;
        end else begin
            state <= next_state;
            valid_out <= 1'b0;

            case (next_state)
                IDLE: begin
                    count <= 2'b0;
                    sum <= 10'b0;
                end
                ACCUM: begin
                    if (valid_in) begin
                        sum <= sum + data_in;
                        count <= count + 1;
                    end
                end
                OUTPUT: begin
                    data_out <= sum + data_in;
                    valid_out <= 1'b1;
                end
            endcase
        end
    end

endmodule