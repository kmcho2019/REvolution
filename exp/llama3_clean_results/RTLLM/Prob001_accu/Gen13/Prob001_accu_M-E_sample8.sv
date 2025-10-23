module accu (
    input clk,
    input rst_n,
    input [7:0] data_in,
    input valid_in,
    output valid_out,
    output [9:0] data_out
);

reg [1:0] state_reg;
reg [9:0] sum_reg [3:0];

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state_reg <= 0;
        for (int i = 0; i < 4; i++) begin
            sum_reg[i] <= 0;
        end
    end else if (valid_in) begin
        case (state_reg)
            0: begin
                sum_reg[0] <= data_in;
                state_reg <= 1;
            end
            1: begin
                sum_reg[1] <= sum_reg[0] + data_in;
                state_reg <= 2;
            end
            2: begin
                sum_reg[2] <= sum_reg[1] + data_in;
                state_reg <= 3;
            end
            3: begin
                sum_reg[3] <= sum_reg[2] + data_in;
                state_reg <= 0;
            end
        endcase
    end
end

assign valid_out = (state_reg == 0) && (sum_reg[3]!= 0);
assign data_out = sum_reg[3];

endmodule