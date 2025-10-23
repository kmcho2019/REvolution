module TopModule(
    input  clk,
    input  reset,
    output reg [31:0] q
);

integer i;
reg [31:0] next_state;

always @(posedge clk) begin
    if (reset) begin
        q <= 32'h1;
    end else begin
        // Initialize the next state as a copy of the current state
        next_state = q;
        
        // Calculate the feedback term (XOR of the taps)
        reg fb = 1'b0;
        reg [31:0] taps[0:3] = '{31, 21, 1, 0};
        for (i = 0; i < 4; i++) begin
            fb = fb ^ q[taps[i]];
        end
        
        // Shift the current state to the right and update the MSB with the feedback term
        next_state = {fb, q[31:1]};
        
        // Update the output register with the next state
        q <= next_state;
    end
end

endmodule