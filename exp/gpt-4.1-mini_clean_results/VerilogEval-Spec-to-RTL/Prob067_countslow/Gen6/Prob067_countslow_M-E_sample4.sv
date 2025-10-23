module TopModule (
    input clk,
    input reset,
    input slowena,
    output reg [3:0] q
);

    reg [2:0] low_cnt;   // counts 0 to 4
    reg [1:0] high_cnt;  // counts 0 to 1

    always @(posedge clk) begin
        if (reset) begin
            low_cnt <= 3'd0;
            high_cnt <= 2'd0;
            q <= 4'd0;
        end else if (slowena) begin
            if (low_cnt == 3'd4) begin
                low_cnt <= 3'd0;
                if (high_cnt == 2'd1) begin
                    high_cnt <= 2'd0;
                    q <= 4'd0;
                end else begin
                    high_cnt <= high_cnt + 2'd1;
                    q <= {high_cnt + 2'd1, 3'd0};
                end
            end else begin
                low_cnt <= low_cnt + 3'd1;
                q <= {high_cnt, low_cnt + 3'd1};
            end
        end else begin
            // hold values when slowena is low
            q <= q;
            low_cnt <= low_cnt;
            high_cnt <= high_cnt;
        end
    end

endmodule