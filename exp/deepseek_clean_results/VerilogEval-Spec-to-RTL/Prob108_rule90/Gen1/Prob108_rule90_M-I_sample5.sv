module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    wire [511:0] next_q;

    // Compute next state with boundary conditions
    assign next_q[0] = q[1];                   // Left boundary = 0
    assign next_q[511] = q[510];               // Right boundary = 0
    
    // Main Rule 90 logic
    assign next_q[510:1] = q[509:0] ^ q[511:2];  // XOR left and right neighbors

    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            q <= next_q;
        end
    end

endmodule