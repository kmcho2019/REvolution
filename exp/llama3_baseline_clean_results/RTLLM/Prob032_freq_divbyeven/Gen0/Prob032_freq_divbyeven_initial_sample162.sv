module freq_diveven(
    input clk,
    input rst_n,
    output reg clk_div
);

parameter NUM_DIV = 10; // even number division factor
reg [3:0] cnt; // 4-bit counter

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin // reset condition
        cnt <= 4'd0;
        clk_div <= 1'b0;
    end else begin // normal operation
        if (cnt < (NUM_DIV / 2 - 1)) begin // increment counter
            cnt <= cnt + 1;
        end else begin // reset counter and toggle clk_div
            cnt <= 4'd0;
            clk_div <= ~clk_div;
        end
    end
end

endmodule