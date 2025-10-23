module TopModule (
    input clk,
    input reset,
    output reg [4:0] q
);

wire feedback = q[0];
wire [4:0] next_state;

always @(posedge clk) begin
    if (reset) begin
        q <= 5'b00001;
    end
    else begin
        // Circular shift right
        next_state = {feedback, q[4:1]};
        
        // Apply taps by selectively inverting bits
        q <= {next_state[4],
              next_state[3],
              next_state[2] ^ feedback,
              next_state[1],
              next_state[0]};
    end
end

endmodule