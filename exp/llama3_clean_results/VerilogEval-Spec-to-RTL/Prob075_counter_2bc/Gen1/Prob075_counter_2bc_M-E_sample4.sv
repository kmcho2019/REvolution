module TopModule(
    input           clk,
    input           areset,
    input           train_valid,
    input           train_taken,
    output reg [1:0] state
);

reg [1:0] inc_cnt;
reg [1:0] dec_cnt;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        // Asynchronous reset to 2'b01
        inc_cnt <= 2'b01;
        dec_cnt <= 2'b00;
    end else begin
        if (train_valid) begin
            if (train_taken) begin
                // Increment inc_cnt
                inc_cnt <= (inc_cnt == 2'b11) ? 2'b11 : inc_cnt + 1'b1;
            end else begin
                // Decrement dec_cnt
                dec_cnt <= (dec_cnt == 2'b11) ? 2'b11 : dec_cnt + 1'b1;
            end
        end
    end
end

always @(*) begin
    if (inc_cnt > dec_cnt) begin
        // inc_cnt is greater, use inc_cnt as state
        state = inc_cnt;
    end else if (inc_cnt < dec_cnt) begin
        // dec_cnt is greater, use dec_cnt as state
        state = 2'b00;
    end else begin
        // inc_cnt and dec_cnt are equal, use 2'b01 as state
        state = 2'b01;
    end
end

endmodule