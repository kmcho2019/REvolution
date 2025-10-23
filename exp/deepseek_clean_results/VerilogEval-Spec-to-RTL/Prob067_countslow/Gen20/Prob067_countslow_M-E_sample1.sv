module TopModule (
    input clk,
    input reset,
    input slowena,
    output [3:0] q
);

reg [9:0] state;
wire [9:0] next_state;

// One-hot state transitions (circular shift)
assign next_state = {state[8:0], state[9]};

// Sequential logic
always @(posedge clk) begin
    if (reset) begin
        state <= 10'b0000000001; // State 0
    end
    else if (slowena) begin
        state <= next_state;
    end
end

// Convert one-hot to binary output
assign q = (state[0] ? 4'd0 :
           (state[1] ? 4'd1 :
           (state[2] ? 4'd2 :
           (state[3] ? 4'd3 :
           (state[4] ? 4'd4 :
           (state[5] ? 4'd5 :
           (state[6] ? 4'd6 :
           (state[7] ? 4'd7 :
           (state[8] ? 4'd8 :
           (state[9] ? 4'd9 : 4'd0)))))))));

endmodule