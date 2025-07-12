module TopModule(
    input clk,
    input areset,
    input x,
    output reg z
);

reg [1:0] state;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 0;
        z <= 0;
    end else begin
        case(state)
            0: begin
                z <= x;
                if (x) begin
                    state <= 1;
                end
            end
            1: begin
                z <= ~x;
            end
        endcase
    end
end

endmodule