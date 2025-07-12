module accu (
    input clk,
    input rst_n,
    input [7:0] data_in,
    input valid_in,
    output valid_out,
    output [9:0] data_out
);

reg [1:0] state;
reg [9:0] sum;
reg [1:0] cnt;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= 0;
        sum <= 0;
        cnt <= 0;
    end else begin
        case (state)
            0: begin
                if (valid_in) begin
                    sum <= data_in;
                    cnt <= 1;
                    state <= 1;
                end else begin
                    sum <= 0;
                    cnt <= 0;
                    state <= 0;
                end
            end
            1: begin
                if (valid_in) begin
                    sum <= sum + data_in;
                    cnt <= 2;
                    state <= 2;
                end else begin
                    sum <= 0;
                    cnt <= 0;
                    state <= 0;
                end
            end
            2: begin
                if (valid_in) begin
                    sum <= sum + data_in;
                    cnt <= 3;
                    state <= 3;
                end else begin
                    sum <= 0;
                    cnt <= 0;
                    state <= 0;
                end
            end
            3: begin
                if (valid_in) begin
                    sum <= sum + data_in;
                    cnt <= 0;
                    state <= 0;
                end else begin
                    sum <= 0;
                    cnt <= 0;
                    state <= 0;
                end
            end
            default: begin
                sum <= 0;
                cnt <= 0;
                state <= 0;
            end
        endcase
    end
end

assign valid_out = (state == 0) && (cnt == 0) && (sum != 0);
assign data_out = sum;

endmodule