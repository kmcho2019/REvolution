module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output done
);

    reg [1:0] byte_cnt;

    always @(posedge clk) begin
        if (reset) begin
            byte_cnt <= 2'b0;
        end else begin
            if (byte_cnt == 2'b0) begin
                byte_cnt <= in[3] ? 2'b01 : 2'b0;
            end else begin
                byte_cnt <= (byte_cnt == 2'b10) ? 2'b0 : byte_cnt + 1'b1;
            end
        end
    end

    assign done = (byte_cnt == 2'b10);

endmodule