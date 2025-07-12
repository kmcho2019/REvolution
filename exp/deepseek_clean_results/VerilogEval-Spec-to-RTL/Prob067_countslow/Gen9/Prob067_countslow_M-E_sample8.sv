module TopModule (
    input clk,
    input reset,
    input slowena,
    output [3:0] q
);

reg [9:0] state;
wire [9:0] next_state;

// One-hot state encoding
assign next_state = slowena ? {state[8:0], state[9]} : state;

// State to output conversion (priority encoder)
assign q = (state[9]) ? 4'd9 :
           (state[8]) ? 4'd8 :
           (state[7]) ? 4'd7 :
           (state[6]) ? 4'd6 :
           (state[5]) ? 4'd5 :
           (state[4]) ? 4'd4 :
           (state[3]) ? 4'd3 :
           (state[2]) ? 4'd2 :
           (state[1]) ? 4'd1 : 4'd0;

always @(posedge clk) begin
    if (reset) begin
        state <= 10'b0000000001; // Initialize to state 0
    end else begin
        state <= next_state;
    end
end

endmodule