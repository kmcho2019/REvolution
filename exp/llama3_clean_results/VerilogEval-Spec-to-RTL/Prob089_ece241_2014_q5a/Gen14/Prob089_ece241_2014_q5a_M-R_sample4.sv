module TopModule(
    input clk,
    input areset,
    input x,
    output reg z
);

typedef enum { NORMAL, COMPLEMENT } state_t;
reg [0:0] state;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= NORMAL;
        z <= 1'b0;
    end else begin
        case (state)
            NORMAL: begin
                z <= x;
                if (x) state <= COMPLEMENT;
            end
            COMPLEMENT: begin
                z <= ~x;
            end
        endcase
    end
end

endmodule