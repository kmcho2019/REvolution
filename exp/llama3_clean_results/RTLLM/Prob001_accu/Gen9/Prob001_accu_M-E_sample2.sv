module accu (
    input clk,
    input rst_n,
    input [7:0] data_in,
    input valid_in,
    output valid_out,
    output [9:0] data_out
);

reg [1:0] state_reg;
reg [1:0] state_next;
reg [9:0] sum_reg;
reg [9:0] sum_next;
reg valid_out_reg;
reg valid_out_next;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state_reg <= 0;
        sum_reg <= 0;
        valid_out_reg <= 0;
    end else begin
        state_reg <= state_next;
        sum_reg <= sum_next;
        valid_out_reg <= valid_out_next;
    end
end

always @(*) begin
    state_next = state_reg;
    sum_next = sum_reg;
    valid_out_next = 0;

    case (state_reg)
        0: begin // idle state
            if (valid_in) begin
                state_next = 1;
                sum_next = data_in;
            end
        end
        1: begin // accumulation state
            if (valid_in) begin
                sum_next = sum_reg + data_in;
                state_next = (sum_reg[9] || sum_reg[8] || sum_reg[7])? 2 : 1;
            end
        end
        2: begin // output state
            valid_out_next = 1;
            state_next = 0;
        end
        default: begin
            state_next = 0;
        end
    endcase
end

assign valid_out = valid_out_reg;
assign data_out = sum_reg;

endmodule