module TopModule (
    input clk,
    input reset,
    output reg [31:0] q
);

reg [4:0] ptr;  // Pointer to track current position (0-31)
reg [31:0] state;

always @(posedge clk) begin
    if (reset) begin
        state <= 32'h1;
        ptr <= 5'd0;
    end else begin
        // Compute next state based on pointer position
        state[ptr] <= (ptr == 5'd0 || ptr == 5'd1 || ptr == 5'd2 || ptr == 5'd22) ? 
                      state[ptr] ^ state[0] : state[(ptr + 1) % 32];
        
        // Update pointer (circular buffer)
        ptr <= (ptr == 5'd31) ? 5'd0 : ptr + 1;
    end
    
    // Output is always the full state
    q <= state;
end

endmodule