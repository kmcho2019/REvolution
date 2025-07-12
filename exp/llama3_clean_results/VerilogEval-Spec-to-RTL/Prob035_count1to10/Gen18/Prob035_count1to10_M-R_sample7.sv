module TopModule (
    input  clk,
    input  reset,
    output [3:0] q
);

reg [3:0] state;

// Combinational logic to determine the next state
wire [3:0] next_state;
assign next_state = (state == 4'd10)? 4'd1 : state + 4'd1;

// Always block to update the current state
always @(posedge clk) begin
    if (reset) begin
        state <= 4'd1;
    end else begin
        state <= next_state;
    end
end

// Directly assign state to output
assign q = state;

endmodule