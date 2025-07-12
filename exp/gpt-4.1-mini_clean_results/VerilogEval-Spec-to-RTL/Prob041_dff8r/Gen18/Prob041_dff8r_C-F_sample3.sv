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
    reg [WIDTH-1:0] q_reg;

    // Instantiate single-bit DFFs for modular clarity; outputs connect to q_bits
    wire [WIDTH-1:0] q_bits;
    genvar i;
    generate
        for (i = 0; i < WIDTH; i = i + 1) begin : gen_dffs
            DFF dff_inst (
                .clk(clk),
                .reset(reset),
                .d(d[i]),
                .q(q_bits[i])
            );
        end
    endgenerate

    // Sync the vector register q_reg with q_bits on clk edge and reset
    // This keeps q_reg aligned with instantiated single-bit DFFs for output consistency
    always @(posedge clk) begin
        if (reset)
            q_reg <= {WIDTH{1'b0}};
        else
            q_reg <= q_bits;
    end

    assign q = q_reg;
endmodule

module TopModule (
    input wire clk,
    input wire reset,
    input wire [7:0] d,
    output wire [7:0] q
);
    DFF_sync_reset_vec #(.WIDTH(8)) dff_vec_inst (
        .clk(clk),
        .reset(reset),
        .d(d),
        .q(q)
    );
endmodule