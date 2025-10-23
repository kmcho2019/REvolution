module TopModule(
    input clk,
    input areset,
    input x,
    output reg z
);

reg [1:0] state; // State A (2'b01) and state B (2'b10)

always @(posedge clk or posedge areset) begin
    if(areset) begin
        state <= 2'b01;
        z <= 1'b0;
    end else begin
        case(state)
            2'b01: begin
                if(!x) begin
                    state <= 2'b01;
                    z <= 1'b0;
                end else begin
                    state <= 2'b10;
                    z <= 1'b1;
                end
            end
            2'b10: begin
                if(!x) begin
                    state <= 2'b10;
                    z <= 1'b1;
                end else begin
                    state <= 2'b10;
                    z <= 1'b0;
                end
            end
            default: begin
                state <= 2'b01;
                z <= 1'b0;
            end
        endcase
    end
end

endmodule