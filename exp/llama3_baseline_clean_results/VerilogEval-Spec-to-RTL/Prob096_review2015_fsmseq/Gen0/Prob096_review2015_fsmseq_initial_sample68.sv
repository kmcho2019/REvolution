module TopModule(
    input clk,
    input reset,
    input data,
    output reg start_shifting
);

reg [1:0] state;

localparam S_IDLE = 2'b00;
localparam S_1 = 2'b01;
localparam S_11 = 2'b10;
localparam S_110 = 2'b11;
localparam S_1101 = 4'b1000; // We need 4 bits to distinguish this state from others

always @ (posedge clk) begin
    if (reset) begin
        state <= S_IDLE;
        start_shifting <= 0;
    end else begin
        case (state)
            S_IDLE: begin
                if (data) begin
                    state <= S_1;
                end
            end
            S_1: begin
                if (data) begin
                    state <= S_11;
                end else begin
                    state <= S_IDLE;
                end
            end
            S_11: begin
                if (data) begin
                    state <= S_11;
                end else begin
                    state <= S_110;
                end
            end
            S_110: begin
                if (data) begin
                    state <= S_1;
                end else begin
                    state <= S_1101;
                end
            end
            S_1101: begin
                start_shifting <= 1;
            end
            default: begin
                state <= S_IDLE;
            end
        endcase
    end
end

always @ (*) begin
    if (state == S_1101) begin
        start_shifting = 1;
    end
end

endmodule