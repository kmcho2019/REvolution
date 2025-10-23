module TopModule (
    input  wire         clk,
    input  wire         load,
    input  wire [511:0] data,
    output reg  [511:0] q
);
    wire [511:0] next_state;

    // Compute next state: next_state[i] = q[i-1] ^ q[i+1], with boundaries zero
    assign next_state[0]     = 1'b0       ^ q[1];
    assign next_state[511]   = q[510]     ^ 1'b0;
    genvar i;
    generate
        for (i = 1; i < 511; i = i + 1) begin : next_logic
            assign next_state[i] = q[i-1] ^ q[i+1];
        end
    endgenerate

    always @(posedge clk) begin
        if (load)
            q <= data;
        else
            q <= next_state;
    end
endmodule