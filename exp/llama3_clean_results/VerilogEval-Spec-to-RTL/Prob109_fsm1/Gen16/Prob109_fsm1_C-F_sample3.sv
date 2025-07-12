module TopModule(
    input        clk,
    input        areset,
    input        in,
    output       out
);

reg state; // current state (0 for A, 1 for B)

// Sequential process to update the current state
always @(posedge clk or posedge areset) begin
    if(areset) begin
        state <= 1'b1; // asynchronously reset into state B
    end else begin
        case (state)
            1'b0: state <= (in) ? 1'b0 : 1'b1;
            1'b1: state <= (in) ? 1'b1 : 1'b0;
            default: state <= 1'b1; // Default to state B
        endcase
    end
end

// Assign output based on the current state
assign out = state;

endmodule