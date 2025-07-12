module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    // Create extended state with boundary zeros
    wire [513:0] q_ext = {1'b0, q, 1'b0};
    
    // Calculate next state in parallel
    wire [511:0] next_state = q_ext[512:1] ^ q_ext[511:0];

    always @(posedge clk) begin
        q <= load ? data : next_state;
    end

endmodule