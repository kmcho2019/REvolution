module TopModule(
    input clk,
    input areset,
    input x,
    output reg z
);

reg state;
reg [1:0] carry;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 1'b0;
        carry <= 2'd0;
    end else begin
        if (~state) begin
            state <= 1'b1;
        end else begin
            if (carry == 2'd0) begin
                carry <= {1'b0, ~x};
                z <= ~x;
            end else begin
                carry <= {carry[0], carry[1] ^ x};
                z <= carry[1] ^ x;
            end
        end
    end
end

endmodule