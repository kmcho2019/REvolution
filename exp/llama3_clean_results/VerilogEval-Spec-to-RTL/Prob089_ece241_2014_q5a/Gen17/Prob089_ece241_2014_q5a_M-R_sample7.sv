module TopModule(
    input clk,
    input areset,
    input x,
    output reg z
);

reg [1:0] state; // 0: Normal, 1: Invert
reg detector;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 0;
        detector <= 0;
        z <= 0;
    end else begin
        case (state)
            0: begin // Normal
                if (x) begin
                    state <= 1;
                    detector <= 1;
                end
                z <= x;
            end
            1: begin // Invert
                z <= ~x;
            end
        endcase
    end
end

endmodule