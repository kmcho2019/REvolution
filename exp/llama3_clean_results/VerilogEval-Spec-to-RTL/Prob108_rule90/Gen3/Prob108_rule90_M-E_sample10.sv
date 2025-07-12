module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output [511:0] q
);

reg [511:0] q_reg;

always @(posedge clk) begin
    if (load) begin
        q_reg <= data;
    end else begin
        // Compute next state using XOR of left and right neighbors
        reg [511:0] next_state;
        reg [511:0] left_shifted, right_shifted;
        
        // Handle left boundary (q[-1] = 0)
        left_shifted[0] = 1'b0;
        left_shifted[511:1] = q_reg[510:0];
        
        // Handle right boundary (q[512] = 0)
        right_shifted[511] = 1'b0;
        right_shifted[510:0] = q_reg[511:1];
        
        // Compute next state using XOR
        next_state = left_shifted ^ right_shifted;
        
        q_reg <= next_state;
    end
end

assign q = q_reg;

endmodule