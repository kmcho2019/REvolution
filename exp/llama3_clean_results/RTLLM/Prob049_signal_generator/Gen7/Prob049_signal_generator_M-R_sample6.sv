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
        if (state == 0) begin
            if (counter == 31) begin
                counter <= counter;
                state <= 1;
            end else begin
                counter <= counter + 1;
                state <= state;
            end
        end else begin
            if (counter == 0) begin
                counter <= counter;
                state <= 0;
            end else begin
                counter <= counter - 1;
                state <= state;
            end
        end
    end
end

assign wave = counter;

endmodule