module TopModule(
    input clk,
    input reset,
    input data,
    output reg start_shifting
);

reg [3:0] state; // 5 states: idle, found_1, found_11, found_110, found_1101
parameter IDLE = 4'b0000;
parameter FOUND_1 = 4'b0001;
parameter FOUND_11 = 4'b0010;
parameter FOUND_110 = 4'b0011;
parameter FOUND_1101 = 4'b0100;

always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        start_shifting <= 0;
    end else begin
        case (state)
            IDLE: begin
                if (data) begin
                    state <= FOUND_1;
                end
            end
            FOUND_1: begin
                if (data) begin
                    state <= FOUND_11;
                end else begin
                    state <= IDLE;
                end
            end
            FOUND_11: begin
                if (data) begin
                    state <= FOUND_110;
                end else begin
                    state <= IDLE;
                end
            end
            FOUND_110: begin
                if (~data) begin
                    state <= FOUND_1101;
                end else begin
                    state <= FOUND_11;
                end
            end
            FOUND_1101: begin
                start_shifting <= 1;
            end
            default: state <= IDLE;
        endcase
    end
end

always @(posedge clk) begin
    if (state == FOUND_1101) begin
        start_shifting <= 1;
    end
end

endmodule