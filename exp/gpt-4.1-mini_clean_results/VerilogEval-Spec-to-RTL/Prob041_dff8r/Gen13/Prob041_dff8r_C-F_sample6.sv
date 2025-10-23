module DFF (
    input wire clk,
    input wire reset,
    input wire d,
    output reg q
);
    always @(posedge clk) begin
        if (reset)
            q <= 1'b0;
        else
            q <= d;
    end
endmodule

module DFF_sync_reset_vec #(
    parameter WIDTH = 8
) (
    input wire clk,
    input wire reset,
    input wire [WIDTH-1:0] d,
    output wire [WIDTH-1:0] q
);
    genvar i;
    generate
        for (i = 0; i < WIDTH; i = i + 1) begin : dff_bits
            DFF dff_inst (
                .clk(clk),
                .reset(reset),
                .d(d[i]),
                .q(q[i])
            );
        end
    endgenerate
endmodule

module TopModule (
    input wire clk,
    input wire reset,
    input wire [7:0] d,
    output wire [7:0] q
);
    // Instantiate 8-bit vector DFF with synchronous reset
    DFF_sync_reset_vec #(.WIDTH(8)) dff_vec_inst (
        .clk(clk),
        .reset(reset),
        .d(d),
        .q(q)
    );
endmodule