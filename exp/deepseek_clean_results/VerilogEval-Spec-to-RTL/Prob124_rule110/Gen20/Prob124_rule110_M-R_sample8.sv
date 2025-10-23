module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    // Combinational next state calculation
    wire [511:0] next_q;

    // Calculate next state for all bits in parallel
    assign next_q[511:0] = {1'b0, q[511:1]} & q[510:0] ? 
                          q[511:0] ^ {1'b0, q[511:1]} : 
                          ~{1'b0, q[511:1]} | q[510:0];

    // State transition logic using continuous assignment
    always @(posedge clk) begin
        q <= load ? data : next_q;
    end

endmodule