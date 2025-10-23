module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output reg done
);

    reg [1:0] byte_cnt;

    always @(posedge clk) begin
        if (reset) begin
            byte_cnt <= 2'b00;
            done <= 1'b0;
        end else begin
            done <= (byte_cnt == 2'b11);
            
            if (byte_cnt == 2'b00) begin
                if (in[3]) byte_cnt <= 2'b01;
            end else begin
                byte_cnt <= byte_cnt + 1;
            end
        end
    end

endmodule