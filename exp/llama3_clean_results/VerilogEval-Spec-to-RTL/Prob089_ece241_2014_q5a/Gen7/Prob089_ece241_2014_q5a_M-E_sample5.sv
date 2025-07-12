module TopModule(
    input clk,
    input areset,
    input x,
    output reg z
);

reg [1:0] state;
reg [1:0] nextState;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 2'b00;
    end else begin
        case (state)
            2'b00: begin
                if (x) begin
                    state <= 2'b01;
                    z <= 1'b1;
                end else begin
                    state <= 2'b00;
                    z <= 1'b0;
                end
            end
            2'b01: begin
                state <= 2'b10;
                z <= ~x;
            end
            2'b10: begin
                state <= 2'b10;
                z <= ~x;
            end
            default: begin
                state <= 2'b00;
            end
        endcase
    end
end

endmodule