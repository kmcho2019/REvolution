module TopModule(
    input clk,
    input reset,
    input data,
    output reg start_shifting
);

reg [2:0] state;

localparam IDLE = 3'b000;
localparam ONE = 3'b001;
localparam TEN = 3'b010;
localparam ONEONE = 3'b011;
localparam ONETENONE = 3'b100;

always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        start_shifting <= 0;
    end else begin
        case (state)
            IDLE: begin
                if (data) begin
                    state <= ONE;
                end
            end
            ONE: begin
                if (data) begin
                    state <= ONEONE;
                end else begin
                    state <= TEN;
                end
            end
            TEN: begin
                if (data) begin
                    state <= ONE;
                end else begin
                    state <= IDLE;
                end
            end
            ONEONE: begin
                if (data) begin
                    state <= ONEONE;
                end else begin
                    state <= ONETENONE;
                end
            end
            ONETENONE: begin
                start_shifting <= 1;
            end
            default: begin
                state <= IDLE;
            end
        endcase
    end
end

endmodule