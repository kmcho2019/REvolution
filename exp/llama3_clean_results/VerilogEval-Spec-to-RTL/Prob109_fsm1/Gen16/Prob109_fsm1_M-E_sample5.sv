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
        case ({state, in})
            2'b00: state <= 1'b1; // A (0) --0--> B
            2'b01: state <= 1'b0; // A (0) --1--> A
            2'b10: state <= 1'b1; // B (1) --0--> B
            2'b11: state <= 1'b1; // B (1) --1--> B
        endcase
    end
end

// Assign output based on the current state
always @(*) begin
    case (state)
        1'b0: out = 1'b0; // state A
        1'b1: out = 1'b1; // state B
    endcase
end

endmodule