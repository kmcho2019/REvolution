module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    wire [511:0] next_q;

    // Combinational logic for Rule 90
    assign next_q[0] = q[1];  // Left boundary (q[-1] is 0)
    assign next_q[511] = q[510];  // Right boundary (q[512] is 0)
    
    genvar i;
    generate
        for (i = 1; i < 511; i = i + 1) begin : rule90
            assign next_q[i] = q[i-1] ^ q[i+1];
        end
    endgenerate

    // Sequential logic
    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            q <= next_q;
        end
    end

endmodule