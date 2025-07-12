module TopModule(
    input        clk,
    input        areset,
    input        in,
    output       out
);

parameter STATE_A = 1'b0;
parameter STATE_B = 1'b1;

reg state; // current state

// Sequential process to update the current state
always @(posedge clk or posedge areset) begin
    if(areset) begin
        state <= STATE_B; // asynchronously reset into state B
    end else begin
        case(state)
            STATE_A: state <= in ? STATE_A : STATE_B; // From A, stay if in=1, move to B if in= STATE_B: state <= in ? STATE_B : STATE_A; // From B, stay if in=1, move to A if in=0
        endcase
    end
end

// Assign output based on the current state
assign out = state;

endmodule