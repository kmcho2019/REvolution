module TopModule(
    input        clk,    // clock
    input        areset, // asynchronous reset
    input        j,      // input j
    input        k,      // input k
    output logic out     // output
);

reg state; // current state

always @(posedge areset or posedge clk) begin
    if (areset) begin
        state <= 1'b0;
    end else begin
        case (state)
            1'b0: state <= j ? 1'b1 : 1'b0;
            1'b1: state <= k ? 1'b0 : 1'b1;
        endcase
    end
end

assign out = state;

endmodule