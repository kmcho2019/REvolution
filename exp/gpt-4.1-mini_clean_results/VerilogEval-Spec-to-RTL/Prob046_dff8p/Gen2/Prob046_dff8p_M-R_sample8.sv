module DFF_NegEdge_SyncReset (
    input clk,
    input reset,
    input d,
    output reg q
);
    always @(negedge clk) begin
        if (reset)
            q <= 1'b0; // This will be overridden at TopModule level
        else
            q <= d;
    end
endmodule

module TopModule (
    input clk,
    input reset,
    input [7:0] d,
    output [7:0] q
);
    // Internal signals for each bit output of DFF
    wire [7:0] dff_q;
    wire [7:0] dff_d;

    // The synchronous reset loads 0x34; otherwise load d.
    assign dff_d = reset ? 8'h34 : d;

    genvar i;
    generate
        for (i=0; i<8; i=i+1) begin : dff_array
            // Instantiate DFFs with synchronous reset. The DFF reset input stays the same, but d input changes based on reset.
            DFF_NegEdge_SyncReset dff_inst (
                .clk(clk),
                .reset(1'b0), // Disable internal reset to avoid conflict, since handled by mux
                .d(dff_d[i]),
                .q(dff_q[i])
            );
        end
    endgenerate

    assign q = dff_q;
endmodule