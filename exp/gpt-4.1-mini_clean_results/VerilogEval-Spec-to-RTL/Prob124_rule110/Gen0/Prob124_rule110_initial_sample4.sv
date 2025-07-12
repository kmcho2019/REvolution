module TopModule(
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    // Temporary wire for next state
    wire [511:0] next_state;

    genvar i;
    generate
        for (i = 0; i < 512; i = i + 1) begin : rule110_logic
            // Neighbors with zero boundary
            wire left  = (i == 511) ? 1'b0 : q[i+1];
            wire center = q[i];
            wire right = (i == 0) ? 1'b0 : q[i-1];

            // next_state logic:
            // next = (~left & center) | (center ^ right) | (left & ~center & ~right);
            assign next_state[i] = (~left & center) | (center ^ right) | (left & ~center & ~right);
        end
    endgenerate

    always @(posedge clk) begin
        if (load)
            q <= data;
        else
            q <= next_state;
    end

endmodule