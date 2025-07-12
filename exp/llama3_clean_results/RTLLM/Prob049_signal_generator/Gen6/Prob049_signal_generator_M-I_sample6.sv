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
        case (state)
            0: begin
                counter <= (counter == 31) ? 31 : counter + 1;
                state <= (counter == 31) ? 1 : 0;
            end
            1: begin
                counter <= (counter == 0) ? 0 : counter - 1;
                state <= (counter == 0) ? 0 : 1;
            end
        endcase
    end
end

assign wave = counter;

endmodule