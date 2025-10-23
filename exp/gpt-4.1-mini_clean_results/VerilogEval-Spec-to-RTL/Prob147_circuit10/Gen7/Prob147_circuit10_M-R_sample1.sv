module TopModule(
    input clk,
    input a,
    input b,
    output reg state,
    output reg q
);

reg next_state;

// Next state combinational logic
always @(*) begin
    case ({state, a, b})
        3'b000: next_state = 1'b0;
        3'b001: next_state = 1'b1;
        3'b010: next_state = 1'b0;
        3'b011: next_state = 1'b1;
        3'b100: next_state = 1'b1;
        3'b101: next_state = 1'b0;
        3'b110: next_state = 1'b1;
        3'b111: next_state = 1'b1;
        default: next_state = state;
    endcase
end

// Output combinational logic based on current state and inputs
always @(*) begin
    case ({state, a, b})
        3'b000: q = 1'b0;
        3'b001: q = 1'b1;
        3'b010: q = 1'b0;
        3'b011: q = 1'b1;
        3'b100: q = 1'b1;
        3'b101: q = 1'b0;
        3'b110: q = 1'b0;
        3'b111: q = 1'b1;
        default: q = 1'b0;
    endcase
end

// Sequential update of state and output q
always @(posedge clk) begin
    state <= next_state;
end

initial begin
    state = 1'b0;
    q = 1'b0;
end

endmodule