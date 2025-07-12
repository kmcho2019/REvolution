module signal_generator(
    input clk,
    input rst_n,
    output reg [4:0] wave
);

reg [4:0] counter;
reg [1:0] state; // 0: idle, 1: incrementing, 2: decrementing

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        counter <= 0;
        state <= 0;
    end else begin
        case (state)
            0: begin
                state <= 1;
                counter <= 0;
            end
            1: begin
                if (counter == 31) begin
                    state <= 2;
                end else begin
                    counter <= counter + 1;
                end
            end
            2: begin
                if (counter == 0) begin
                    state <= 1;
                end else begin
                    counter <= counter - 1;
                end
            end
            default: begin
                state <= 0;
                counter <= 0;
            end
        endcase
    end
end

assign wave = counter;

endmodule