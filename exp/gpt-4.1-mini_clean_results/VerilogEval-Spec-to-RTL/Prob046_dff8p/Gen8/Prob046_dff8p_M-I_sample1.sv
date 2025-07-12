module DFF (
    input clk,
    input reset,
    input d,
    output reg q,
    input integer bit_idx
);
    // Hardcoded reset value 0x34
    localparam [7:0] RESET_VALUE = 8'h34;
    
    always @(negedge clk) begin
        if (reset)
            q <= RESET_VALUE[bit_idx];
        else
            q <= d;
    end
endmodule

module TopModule (
    input        clk,
    input        reset,
    input  [7:0] d,
    output [7:0] q
);

    genvar i;

    generate
        for (i = 0; i < 8; i = i + 1) begin : dffs
            // Pass bit index to DFF for selecting reset bit
            DFF #(.bit_idx(i)) dff_i (
                .clk(clk),
                .reset(reset),
                .d(d[i]),
                .q(q[i]),
                .bit_idx(i)
            );
        end
    endgenerate

endmodule