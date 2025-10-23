module TopModule (
    input  clk,
    input  reset,
    output [3:0] q
);

reg [3:0] state;
reg [3:0] next_state;

// Combinational logic to determine the next state
always @(*) begin
    if (reset) begin
        next_state = 4'd1;
    end else if (state == 4'd10) begin
        next_state = 4'd1;
    end else begin
        next_state = state + 4'd1;
    end
end

// Sequential logic to update the state
always @(posedge clk) begin
    state <= next_state;
end

// Directly assign state to output
assign q = state;

endmodule