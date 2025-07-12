module TopModule(
    input clk,
    input reset,
    input data,
    output reg start_shifting
);

reg [1:0] state;
localparam IDLE = 2'b00;
localparam SEEN1 = 2'b01;
localparam SEEN11 = 2'b10;
localparam SEEN110 = 2'b11;
localparam SEEN1101 = 3'b100;

always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        start_shifting <= 0;
    end else begin
        case (state)
            IDLE: begin
                if (data == 1'b1) begin
                    state <= SEEN1;
                end
            end
            SEEN1: begin
                if (data == 1'b1) begin
                    state <= SEEN11;
                end else begin
                    state <= IDLE;
                end
            end
            SEEN11: begin
                if (data == 1'b0) begin
                    state <= SEEN110;
                end else begin
                    state <= SEEN1;
                end
            end
            SEEN110: begin
                if (data == 1'b1) begin
                    state <= SEEN1101;
                    start_shifting <= 1'b1;
                end else begin
                    state <= IDLE;
                end
            end
            default: begin // SEEN1101
                // Do nothing, just stay in this state
            end
        endcase
    end
end

endmodule