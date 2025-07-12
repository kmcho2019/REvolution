module TopModule(
    input  clk,
    input  reset,
    input  j,
    input  k,
    output reg out
);

reg state = 1'b0; // Initialize state to OFF directly

always @(posedge clk) begin
    if (reset) state <= 1'b0; // Reset to OFF state
    else begin
        case (state)
            1'b0: state <= j ? 1'b1 : 1'b0; 
            1'b1: state <= ~k; 
        endcase
    end
end

assign out = state;

endmodule