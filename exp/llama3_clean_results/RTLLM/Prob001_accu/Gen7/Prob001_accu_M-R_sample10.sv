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

localparam IDLE = 2'b00;
localparam ACCU = 2'b01;
localparam DONE = 2'b10;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state_reg <= IDLE;
        sum_reg <= 0;
    end else begin
        case (state_reg)
            IDLE: begin
                if (valid_in) begin
                    state_reg <= ACCU;
                    sum_reg <= data_in;
                end
            end
            ACCU: begin
                if (valid_in) begin
                    sum_reg <= sum_reg + data_in;
                    if (sum_reg[9:8] == 2'b11) begin // Overflow condition
                        state_reg <= DONE;
                    end else if (sum_reg[8] == 1'b1) begin // Half full condition
                        if (data_in[7:0] >= 8'd4) begin
                            state_reg <= DONE;
                        end
                    end
                end
            end
            DONE: begin
                state_reg <= IDLE;
            end
        endcase
    end
end

assign valid_out = (state_reg == DONE);
assign data_out = sum_reg;

endmodule