module TopModule(
    input clk,
    input reset,
    input data,
    output reg start_shifting
);

reg [3:0] state;

localparam IDLE = 4'b0000;
localparam SEEN_1 = 4'b0001;
localparam SEEN_11 = 4'b0010;
localparam SEEN_110 = 4'b0011;
localparam SEEN_1101 = 4'b0100;

always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        start_shifting <= 0;
    end else begin
        case (state)
            IDLE: begin
                if (data) begin
                    state <= SEEN_1;
                end else begin
                    state <= IDLE;
                end
            end
            SEEN_1: begin
                if (data) begin
                    state <= SEEN_11;
                end else begin
                    state <= IDLE;
                end
            end
            SEEN_11: begin
                if (!data) begin
                    state <= SEEN_110;
                end else begin
                    state <= SEEN_1;
                end
            end
            SEEN_110: begin
                if (data) begin
                    state <= SEEN_1101;
                end else begin
                    state <= IDLE;
                end
            end
            SEEN_1101: begin
                start_shifting <= 1;
                state <= SEEN_1101;
            end
            default: begin
                state <= IDLE;
            end
        endcase
    end
end

endmodule