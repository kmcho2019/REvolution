module TopModule(
    input clk,
    input areset,
    input in,
    output reg out
);

reg state;

always @(posedge clk or posedge areset) begin
    if (areset) state <= 1;
    else case(state)
        0: state <= in ? 0 : 1;
        1: state <= in ? 1 : 0;
    endcase
end

assign out = state;

endmodule