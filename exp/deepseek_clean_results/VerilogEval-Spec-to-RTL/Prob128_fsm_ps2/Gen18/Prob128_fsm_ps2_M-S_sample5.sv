module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output reg done
);

    reg [1:0] cnt;

    always @(posedge clk) begin
        if (reset) begin
            cnt <= 2'b00;
            done <= 1'b0;
        end else begin
            if (cnt == 2'b00) begin
                done <= 1'b0;
                if (in[3]) cnt <= 2'b01;
            end else begin
                cnt <= cnt + 1;
                done <= (cnt == 2'b10);
            end
        end
    end

endmodule