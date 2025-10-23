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
localparam SEEN110 = 3'b100;
localparam FOUND = 3'b111;

always @ (posedge clk) begin
    if (reset) begin
        state <= 2'b00;
        start_shifting <= 1'b0;
    end
    else begin
        case (state)
            IDLE: begin
                if (data == 1'b1) begin
                    state <= SEEN1;
                end
            end
            SEEN1: begin
                if (data == 1'b1) begin
                    state <= SEEN11;
                end
                else if (data == 1'b0) begin
                    state <= IDLE;
                end
            end
            SEEN11: begin
                if (data == 1'b0) begin
                    state <= SEEN110;
                end
                else if (data == 1'b1) begin
                    state <= SEEN1;
                end
            end
            SEEN110: begin
                if (data == 1'b1) begin
                    state <= FOUND;
                end
                else if (data == 1'b0) begin
                    state <= IDLE;
                end
            end
            default: begin // FOUND state
                state <= FOUND;
            end
        endcase
    end
end

always @ (*) begin
    case (state)
        FOUND: start_shifting = 1'b1;
        default: start_shifting = 1'b0;
    endcase
end

endmodule