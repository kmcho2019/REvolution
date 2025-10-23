module signal_generator(
    input clk,
    input rst_n,
    output reg [4:0] wave
);

reg [4:0] counter;
reg state; // 0: incrementing, 1: decrementing

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        state <= 0;
    end else begin
        if ((state == 0 && counter == 31) || (state == 1 && counter == 0)) begin
            state <= ~state;
        end
    end
end

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        counter <= 0;
    end else begin
        if (state == 0) begin
            counter <= (counter == 31) ? 31 : counter + 1;
        end else begin
            counter <= (counter == 0) ? 0 : counter - 1;
        end
    end
end

assign wave = counter;

endmodule