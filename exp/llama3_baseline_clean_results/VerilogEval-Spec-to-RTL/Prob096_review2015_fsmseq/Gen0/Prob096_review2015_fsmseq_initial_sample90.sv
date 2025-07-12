module TopModule(
    input clk,
    input reset,
    input data,
    output reg start_shifting
);

reg [2:0] state; // 3 bits for 5 states (2^2 = 4, 2^3 = 8)
localparam IDLE = 3'b000;
localparam SEEN1 = 3'b001;
localparam SEEN11 = 3'b010;
localparam SEEN110 = 3'b011;
localparam SEEN1101 = 3'b100;

always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        start_shifting <= 0;
    end else begin
        case (state)
            IDLE: begin
                if (data) begin
                    state <= SEEN1;
                end else begin
                    state <= IDLE;
                end
            end
            SEEN1: begin
                if (data) begin
                    state <= SEEN11;
                end else begin
                    state <= SEEN1;
                end
            end
            SEEN11: begin
                if (~data) begin
                    state <= SEEN110;
                end else begin
                    state <= SEEN1;
                end
            end
            SEEN110: begin
                if (data) begin
                    state <= SEEN1101;
                end else begin
                    state <= IDLE;
                end
            end
            SEEN1101: begin
                start_shifting <= 1;
                state <= SEEN1101;
            end
            default: state <= IDLE;
        endcase
    end
end

endmodule