module TopModule (
    input clk,
    input a,
    input b,
    output reg state,
    output q
);

wire toggle = b & ~a;
wire next_state = state ^ toggle;

always @(posedge clk) begin
    state <= next_state;
end

assign q = state;

initial begin
    state = 1'b0; // Initialize state to 0 for simulation start
end

endmodule