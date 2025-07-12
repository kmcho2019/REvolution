module accu(
    input clk,
    input rst_n,
    input [7:0] data_in,
    input valid_in,
    output valid_out,
    output [9:0] data_out
);

reg [1:0] state;
reg [1:0] count;
reg [9:0] sum;
reg [9:0] data_out_reg;

assign valid_out = (state == 2'b11);
assign data_out = data_out_reg;

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        state <= 2'b00;
        count <= 2'b00;
        sum <= 10'b0;
        data_out_reg <= 10'b0;
    end else begin
        case (state)
            2'b00: begin // IDLE state
                if (valid_in) begin
                    state <= 2'b01;
                    count <= 2'b01;
                    sum <= data_in;
                end else begin
                    state <= 2'b00;
                end
            end
            2'b01: begin // ACCUMULATE state
                if (valid_in) begin
                    count <= count + 1'b1;
                    sum <= sum + data_in;
                    if (count == 2'b11) begin
                        state <= 2'b10;
                    end
                end else begin
                    state <= 2'b01;
                end
            end
            2'b10: begin // OUTPUT state
                data_out_reg <= sum;
                state <= 2'b11;
            end
            2'b11: begin // RESET state
                state <= 2'b00;
                count <= 2'b00;
                sum <= 10'b0;
                data_out_reg <= 10'b0;
            end
        endcase
    end
end

endmodule