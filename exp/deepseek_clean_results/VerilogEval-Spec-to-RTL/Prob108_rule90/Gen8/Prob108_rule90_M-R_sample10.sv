module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    // Create extended version of q with boundary bits
    wire [513:0] extended_q = {1'b0, q, 1'b0};
    
    // Compute next state using vector XOR of left and right neighbors
    wire [511:0] next_state = extended_q[512:1] ^ extended_q[511:0];

    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            q <= next_state;
        end
    end

endmodule