module TopModule(
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);
    wire [511:0] next_state;

    // Generate next state according to Rule 90 with boundary bits zero
    assign next_state[0]   = q[1];                 // left neighbor = 0, right = q[1]
    assign next_state[511] = q[510];               // left = q[510], right neighbor = 0
    genvar i;
    generate
        for (i = 1; i < 511; i = i + 1) begin : next_state_gen
            assign next_state[i] = q[i-1] ^ q[i+1];
        end
    endgenerate

    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            q <= next_state;
        end
    end

endmodule