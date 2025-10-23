module TopModule(
    input clk,
    input reset,
    input data,
    output reg start_shifting
);

reg [2:0] state; // idle = 3'b000, seen1 = 3'b001, seen11 = 3'b010, seen110 = 3'b011, found = 3'b100

always @(posedge clk) begin
    if (reset) begin
        state <= 3'b000; // idle
        start_shifting <= 0;
    end else begin
        case (state)
            3'b000: begin // idle
                if (data) begin
                    state <= 3'b001; // seen1
                end else begin
                    state <= 3'b000; // idle
                end
            end
            3'b001: begin // seen1
                if (data) begin
                    state <= 3'b010; // seen11
                end else begin
                    state <= 3'b000; // idle
                end
            end
            3'b010: begin // seen11
                if (data) begin
                    state <= 3'b011; // seen110
                end else begin
                    state <= 3'b001; // seen1
                end
            end
            3'b011: begin // seen110
                if (data == 1'b0) begin
                    state <= 3'b100; // found
                end else begin
                    state <= 3'b000; // idle
                end
            end
            3'b100: begin // found
                start_shifting <= 1;
            end
        endcase
    end
end

endmodule