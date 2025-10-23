module accu (
    input clk,
    input rst_n,
    input [7:0] data_in,
    input valid_in,
    output valid_out,
    output [9:0] data_out
);

reg [1:0] state_reg;
reg [9:0] sum_reg;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state_reg <= 0; // IDLE
        sum_reg <= 0;
    end else begin
        case (state_reg)
            0: begin // IDLE
                if (valid_in) begin
                    sum_reg <= data_in;
                    state_reg <= 1; // ACCUM_1
                end
            end
            1: begin // ACCUM_1
                if (valid_in) begin
                    sum_reg <= sum_reg + data_in;
                    state_reg <= 2; // ACCUM_2
                end
            end
            2: begin // ACCUM_2
                if (valid_in) begin
                    sum_reg <= sum_reg + data_in;
                    state_reg <= 3; // ACCUM_3
                end
            end
            3: begin // ACCUM_3
                if (valid_in) begin
                    sum_reg <= sum_reg + data_in;
                    state_reg <= 0; // OUTPUT and reset to IDLE
                end
            end
            default: state_reg <= 0; // IDLE
        endcase
    end
end

assign valid_out = (state_reg == 0) && (sum_reg != 0);
assign data_out = sum_reg;

endmodule