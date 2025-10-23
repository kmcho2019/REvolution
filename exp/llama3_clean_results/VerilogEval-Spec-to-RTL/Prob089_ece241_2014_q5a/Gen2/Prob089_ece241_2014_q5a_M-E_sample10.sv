module TopModule(
    input clk,
    input areset,
    input x,
    output reg z
);

reg detector;
reg [1:0] state;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        detector <= 0;
        state <= 0;
        z <= 0;
    end else begin
        case (state)
            0: begin
                if (x) begin
                    detector <= 1;
                    state <= 1;
                    z <= 1;
                end
            end
            1: begin
                z <= ~x;
            end
            default: ;
        endcase
    end
end

endmodule