module TopModule(
    input clk,
    input a,
    input b,
    output reg q,
    output reg state
);

always @(posedge clk) begin
    case({a, b})
        2'b01: state <= 1'b1; // Set state to 1 when a=0, b=1
        2'b11: state <= 1'b0; // Reset state to 0 when a=1, b=1
        default: state <= state; // Otherwise, retain current state
    endcase
end

always @(*) begin
    q = state || (a && ~b); // q is 1 if state is 1 or a=1, b=0
end

endmodule