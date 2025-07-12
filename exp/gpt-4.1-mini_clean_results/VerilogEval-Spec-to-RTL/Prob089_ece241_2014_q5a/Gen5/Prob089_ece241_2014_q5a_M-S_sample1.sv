module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire x,
    output reg  z
);

    reg state; // 0: waiting for first 1, 1: inverting bits

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 1'b0;
            z <= 1'b0;
        end else begin
            case (state)
                1'b0: begin
                    z <= x;
                    if (x)
                        state <= 1'b1;
                end
                1'b1: begin
                    z <= ~x;
                    state <= 1'b1;
                end
            endcase
        end
    end

endmodule