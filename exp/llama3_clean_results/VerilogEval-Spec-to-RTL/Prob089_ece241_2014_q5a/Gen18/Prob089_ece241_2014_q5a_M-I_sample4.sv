module TopModule(
    input clk,
    input areset,
    input x,
    output reg z
);

reg [1:0] state; // 0: idle, 1: running, 2: complement

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 0;
        z <= 0;
    end else begin
        case (state)
            0: begin
                if (x) begin
                    state <= 1;
                    z <= x;
                end else begin
                    state <= 0;
                    z <= 0;
                end
            end
            1: begin
                state <= 2;
                z <= ~x;
            end
            2: begin
                z <= ~x;
            end
        endcase
    end
end

endmodule