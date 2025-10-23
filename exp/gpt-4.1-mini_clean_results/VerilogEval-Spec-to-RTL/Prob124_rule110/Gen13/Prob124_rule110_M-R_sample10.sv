module TopModule (
    input  wire         clk,
    input  wire         load,
    input  wire [511:0] data,
    output reg  [511:0] q
);

    // Zero-extend current state for boundary conditions
    wire [513:0] ext_q;
    assign ext_q = {1'b0, q, 1'b0};

    // Compute next state combinationally using Rule 110 formula
    wire [511:0] next_state;
    genvar i;
    generate
        for (i = 0; i < 512; i = i + 1) begin : compute_next
            wire left   = ext_q[i+2];
            wire center = ext_q[i+1];
            wire right  = ext_q[i];
            assign next_state[i] = (~left & center) | (center ^ right);
        end
    endgenerate

    // Sequential process: load input data or update q with next state
    always @(posedge clk) begin
        if (load)
            q <= data;
        else
            q <= next_state;
    end

endmodule