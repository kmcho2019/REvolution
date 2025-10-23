module signal_generator(
    input clk,
    input rst_n,
    output reg [4:0] wave
);

reg [4:0] counter;
reg state; // 0: incrementing, 1: decrementing

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        counter <= 0;
        state <= 0;
    end else begin
        if (counter == 31 && ~state) begin
            state <= 1;
        end else if (counter == 0 && state) begin
            state <= 0;
        end

        if (~state) begin
            counter <= (counter == 31) ? 31 : counter + 1;
        end else begin
            counter <= (counter == 0) ? 0 : counter - 1;
        end
    end
end

assign wave = counter;

endmodule