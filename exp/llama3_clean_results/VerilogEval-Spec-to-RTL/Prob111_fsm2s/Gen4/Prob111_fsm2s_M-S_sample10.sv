module TopModule (
    input  clk,
    input  reset,
    input  j,
    input  k,
    output reg out
);

reg state;

always_ff @(posedge clk) begin
    if (reset) begin
        state <= 1'b0; // OFF
    end else begin
        case(state)
            1'b0: state <= j? 1'b1 : 1'b0; // OFF to ON or stay OFF
            1'b1: state <= ~k? 1'b1 : 1'b0; // ON to OFF or stay ON
        endcase
    end
end

assign out = state;

endmodule