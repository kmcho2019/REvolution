module accu (
    input clk,
    input rst_n,
    input [7:0] data_in,
    input valid_in,
    output valid_out,
    output [9:0] data_out
);

reg [7:0] fifo [3:0];
reg [1:0] cnt;
reg [9:0] sum;
reg full;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt <= 0;
        sum <= 0;
        full <= 0;
        for (int i = 0; i < 4; i++) begin
            fifo[i] <= 0;
        end
    end else if (valid_in) begin
        if (!full) begin
            fifo[cnt] <= data_in;
            cnt <= cnt + 1;
            if (cnt == 4) begin
                full <= 1;
            end
        end
    end else if (full) begin
        sum <= fifo[0] + fifo[1] + fifo[2] + fifo[3];
        cnt <= 0;
        full <= 0;
        for (int i = 0; i < 4; i++) begin
            fifo[i] <= 0;
        end
    end
end

assign valid_out = full;
assign data_out = sum;

endmodule