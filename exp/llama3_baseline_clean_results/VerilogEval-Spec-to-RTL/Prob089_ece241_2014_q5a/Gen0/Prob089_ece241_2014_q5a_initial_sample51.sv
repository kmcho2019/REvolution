module TopModule(
    input clk,
    input areset,
    input x,
    output z
);

reg [1:0] state; // 0: idle, 1: running, 2: inverting
reg invert;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 0;
        invert <= 1'b0;
        z <= 1'b0;
    end else begin
        case(state)
            0: begin // idle
                if (~areset) begin
                    state <= 1;
                    invert <= 1'b0;
                    z <= 1'b0;
                end
            end
            1: begin // running
                if (x) begin
                    state <= 2; // start inverting
                    z <= ~x;
                end else begin
                    z <= ~x;
                end
            end
            2: begin // inverting
                z <= ~x;
            end
        endcase
    end
end

endmodule