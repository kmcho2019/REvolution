module TopModule (
    input clk,
    input a,
    output reg q
);

// State definition
reg state;

always @(posedge clk) begin
    case (state)
        1'b0: state <= ~a;  // Move to State 1 if a is 0
        1'b1: state <= a;    // Move to State 0 if a is 1
    endcase
end

// Output assignment
always @(*) begin
    q = state;
end

initial begin
    state = 1'b0;  // Initialize to State 0
    q = 1'b0;
end

endmodule