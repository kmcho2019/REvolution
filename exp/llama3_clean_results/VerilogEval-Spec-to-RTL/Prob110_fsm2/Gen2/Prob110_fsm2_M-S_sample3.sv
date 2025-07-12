module TopModule(
    input clk,
    input areset,
    input j,
    input k,
    output reg out
);

reg state;

always @(posedge areset or posedge clk) begin
    if(areset) begin
        state <= 1'b0;
    end else begin
        case(state)
            1'b0: state <= j? 1'b1 : 1'b0;
            1'b1: state <= k? 1'b0 : 1'b1;
        endcase
    end
end

assign out = state;

endmodule