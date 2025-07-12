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
    localparam COUNT1 = 2'b01;
    localparam COUNT2 = 2'b10;
    localparam COUNT3 = 2'b11;

    reg [1:0] state, next_state;
    reg [9:0] acc_reg, next_acc;

    // State transition logic
    always @(*) begin
        next_state = state;
        next_acc = acc_reg;
        valid_out = 1'b0;
        data_out = 10'b0;

        if (valid_in) begin
            case (state)
                IDLE: begin
                    next_state = COUNT1;
                    next_acc = data_in;
                end
                COUNT1: begin
                    next_state = COUNT2;
                    next_acc = acc_reg + data_in;
                end
                COUNT2: begin
                    next_state = COUNT3;
                    next_acc = acc_reg + data_in;
                end
                COUNT3: begin
                    next_state = IDLE;
                    next_acc = 10'b0;
                    data_out = acc_reg + data_in;
                    valid_out = 1'b1;
                end
            endcase
        end
    end

    // Sequential logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
            acc_reg <= 10'b0;
        end else begin
            state <= next_state;
            acc_reg <= next_acc;
        end
    end

endmodule