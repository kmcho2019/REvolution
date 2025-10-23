module TopModule (
    input  wire         clk,
    input  wire         load,
    input  wire [511:0] data,
    output reg  [511:0] q
);

    wire [511:0] next_state;

    genvar i;
    generate
        for (i = 0; i < 512; i = i + 1) begin : next_state_gen
            wire left   = (i < 511) ? q[i+1] : 1'b0;
            wire center = q[i];
            wire right  = (i > 0) ? q[i-1] : 1'b0;
            assign next_state[i] = (~left & center) | (center ^ right);
        end
    endgenerate

    always @(posedge clk) begin
        if (load)
            q <= data;
        else
            q <= next_state;
    end

endmodule