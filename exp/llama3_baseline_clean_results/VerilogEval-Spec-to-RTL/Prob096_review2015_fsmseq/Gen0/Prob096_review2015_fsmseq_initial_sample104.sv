module TopModule(
    input clk,
    input reset,
    input data,
    output reg start_shifting
);

reg [1:0] state; // 00: IDLE, 01: ONE, 10: TEN, 11: TEEN
localparam IDLE = 2'b00;
localparam ONE = 2'b01;
localparam TEN = 2'b10;
localparam TEEN = 2'b11;

always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        start_shifting <= 0;
    end else begin
        case (state)
            IDLE: begin
                if (data) begin
                    state <= ONE;
                end else begin
                    state <= IDLE;
                end
            end
            ONE: begin
                if (data) begin
                    state <= TEN;
                end else begin
                    state <= IDLE;
                end
            end
            TEN: begin
                if (data) begin
                    state <= ONE;
                end else begin
                    state <= TEEN;
                end
            end
            TEEN: begin
                if (data) begin
                    state <= ONE;
                end else begin
                    state <= IDLE;
                    start_shifting <= 1;
                end
            end
        endcase
    end
end

endmodule