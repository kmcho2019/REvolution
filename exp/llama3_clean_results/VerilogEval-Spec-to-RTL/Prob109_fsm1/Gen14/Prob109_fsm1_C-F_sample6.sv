module TopModule(
    input        clk,
    input        areset,
    input        in,
    output       out
);

reg state; // 1 represents state B, 0 represents state A

// Sequential logic to update current state
always @(posedge clk or posedge areset) begin
    if(areset) begin
        state <= 1'b1; // asynchronously reset into state B
    end else begin
        case(state)
            1'b0: state <= in? 1'b0 : 1'b1; // From A (0), stay if in=1, move to B if in=0
            1'b1: state <= in? 1'b1 : 1'b0; // From B (1), stay if in=1, move to A if in=0
        endcase
    end
end

// Output logic (Moore machine, output based on current state)
assign out = state;

endmodule