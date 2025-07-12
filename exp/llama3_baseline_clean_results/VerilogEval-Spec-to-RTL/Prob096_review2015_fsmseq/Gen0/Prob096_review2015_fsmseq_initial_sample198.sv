module TopModule(
    input clk,
    input reset,
    input data,
    output reg start_shifting
);

reg [1:0] state;

localparam IDLE = 2'b00;
localparam SEEN_1 = 2'b01;
localparam SEEN_11 = 2'b10;
localparam SEEN_110 = 2'b11;

always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        start_shifting <= 0;
    end else begin
        case (state)
            IDLE: begin
                if (data) begin
                    state <= SEEN_1;
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
                if (~data) begin
                    state <= SEEN_110;
                end else begin
                    state <= SEEN_1;
                end
            end
            SEEN_110: begin
                if (data) begin
                    state <= IDLE;
                    start_shifting <= 1;
                end else begin
                    state <= IDLE;
                end
            end
        endcase
    end
end

endmodule