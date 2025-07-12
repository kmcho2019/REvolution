module TopModule(
    input clk,
    input reset,
    input data,
    output reg start_shifting
);

reg [2:0] state; // idle (0), got_1 (1), got_11 (2), got_110 (3), got_1101 (4)
localparam IDLE = 3'b000;
localparam GOT_1 = 3'b001;
localparam GOT_11 = 3'b010;
localparam GOT_110 = 3'b011;
localparam GOT_1101 = 3'b100;

always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        start_shifting <= 0;
    end else begin
        case (state)
            IDLE: begin
                if (data) begin
                    state <= GOT_1;
                end
            end
            GOT_1: begin
                if (data) begin
                    state <= GOT_11;
                end else begin
                    state <= IDLE;
                end
            end
            GOT_11: begin
                if (data) begin
                    state <= GOT_110;
                end else begin
                    state <= IDLE;
                end
            end
            GOT_110: begin
                if (data == 1'b0) begin
                    state <= GOT_1101;
                    start_shifting <= 1;
                end else begin
                    state <= GOT_11;
                end
            end
            GOT_1101: begin
                // stay in this state and keep start_shifting = 1
            end
        endcase
    end
end

endmodule