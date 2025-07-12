module TopModule(
    input  clk,
    input  areset,
    input  x,
    output reg z
);

reg [31:0] inverted_num = 0;
reg [1:0] state = 0; // 0: IDLE, 1: INVERT
reg add = 0;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        inverted_num <= 0;
        state <= 0;
        add <= 0;
        z <= 0;
    end else begin
        case (state)
            0: begin // IDLE
                if (~areset) begin
                    state <= 1;
                end
            end
            1: begin // INVERT
                inverted_num <= {inverted_num[30:0], ~x};
                z <= ~x;
                if (areset) begin
                    state <= 0;
                    if (inverted_num[0] == 1'b1) begin
                        inverted_num <= inverted_num + 1;
                    end
                    z <= inverted_num[0];
                end
            end
        endcase
    end
end

endmodule