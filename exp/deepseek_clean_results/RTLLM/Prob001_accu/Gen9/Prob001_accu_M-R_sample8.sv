module accu (
    input clk,
    input rst_n,
    input [7:0] data_in,
    input valid_in,
    output valid_out,
    output [9:0] data_out
);

    // State encoding
    localparam IDLE = 2'b00;
    localparam COUNT1 = 2'b01;
    localparam COUNT2 = 2'b10;
    localparam COUNT3 = 2'b11;

    reg [1:0] state, next_state;
    reg [9:0] accumulator;
    reg [9:0] sum_reg;

    // Next state logic
    always @(*) begin
        case (state)
            IDLE:   next_state = valid_in ? COUNT1 : IDLE;
            COUNT1: next_state = valid_in ? COUNT2 : COUNT1;
            COUNT2: next_state = valid_in ? COUNT3 : COUNT2;
            COUNT3: next_state = valid_in ? IDLE : COUNT3;
            default: next_state = IDLE;
        endcase
    end

    // State transition and accumulation
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
            accumulator <= 10'b0;
            sum_reg <= 10'b0;
        end
        else begin
            state <= next_state;
            
            if (valid_in) begin
                if (state == COUNT3) begin
                    // On 4th input, store sum and reset accumulator
                    sum_reg <= accumulator + data_in;
                    accumulator <= 10'b0;
                end
                else begin
                    // Accumulate input
                    accumulator <= accumulator + data_in;
                end
            end
        end
    end

    // Output assignments
    assign valid_out = (state == COUNT3) && valid_in;
    assign data_out = sum_reg;

endmodule