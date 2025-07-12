module TopModule (
    input  wire         clk,
    input  wire         load,
    input  wire [511:0] data,
    output reg  [511:0] q
);
    wire [511:0] next_state;
    wire [512:0] padded_q;

    // Pad current state with zeros on both sides for boundary conditions
    assign padded_q = {1'b0, q, 1'b0};

    // Compute next state: each cell's next state is XOR of left and right neighbors
    genvar i;
    generate
        for (i = 0; i < 512; i = i + 1) begin : compute_next
            assign next_state[i] = padded_q[i] ^ padded_q[i+2];
        end
    endgenerate

    // Sequential logic: load new state or update with next state on clock
    always @(posedge clk) begin
        if (load)
            q <= data;
        else
            q <= next_state;
    end
endmodule