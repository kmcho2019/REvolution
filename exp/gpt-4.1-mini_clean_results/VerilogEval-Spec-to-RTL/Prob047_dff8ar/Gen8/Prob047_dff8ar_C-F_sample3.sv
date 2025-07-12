module DFF_AsyncReset #(
    parameter WIDTH = 1
) (
    input                   clk,
    input                   areset,
    input  [WIDTH-1:0]      d,
    output reg [WIDTH-1:0]  q
);
    always @(posedge clk or posedge areset) begin
        if (areset)
            q <= {WIDTH{1'b0}};
        else
            q <= d;
    end
endmodule

module TopModule (
    input         clk,
    input         areset,
    input  [7:0]  d,
    output [7:0]  q
);

    // Instantiate 8 single-bit DFF_AsyncReset modules using generate
    genvar i;
    wire [7:0] q_internal;

    generate
        for (i = 0; i < 8; i = i + 1) begin : dff_array
            DFF_AsyncReset #(.WIDTH(1)) dff_inst (
                .clk(clk),
                .areset(areset),
                .d(d[i]),
                .q(q_internal[i])
            );
        end
    endgenerate

    assign q = q_internal;

endmodule