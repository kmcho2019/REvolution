module TopModule (
    input        clk,
    input        load,
    input  [511:0] data,
    output reg [511:0] q
);

    wire [511:0] next_state;
    wire update_enable;

    // Boundary bits
    assign next_state[0]   = q[1];         // left neighbor assumed zero, so next = 0 ^ q[1] = q[1]
    assign next_state[511] = q[510];       // right neighbor assumed zero, so next = q[510] ^ 0 = q[510]

    // Middle bits: XOR of left and right neighbors without conditions
    genvar i;
    generate
        for (i = 1; i < 511; i = i + 1) begin : gen_next_state
            assign next_state[i] = q[i-1] ^ q[i+1];
        end
    endgenerate

    // Update enable: activate when load is asserted or state changes
    assign update_enable = load | (next_state != q);

    always @(posedge clk) begin
        if (update_enable) begin
            if (load) 
                q <= data;
            else 
                q <= next_state;
        end
    end

endmodule