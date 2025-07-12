module signal_generator(
    input clk,
    input rst_n,
    output reg [4:0] wave
);

reg [4:0] counter;
reg state; // 0: incrementing, 1: decrementing
reg clk_enable; // clock enable signal

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        counter <= 0;
        state <= 0;
        clk_enable <= 1;
    end else if (clk_enable) begin
        case (state)
            0: begin
                if (counter == 31) begin
                    state <= 1;
                end
                counter <= (counter == 31)? 31 : counter + 1;
            end
            1: begin
                if (counter == 0) begin
                    state <= 0;
                end
                counter <= (counter == 0)? 0 : counter - 1;
            end
        endcase
    end
end

assign wave = counter;

endmodule