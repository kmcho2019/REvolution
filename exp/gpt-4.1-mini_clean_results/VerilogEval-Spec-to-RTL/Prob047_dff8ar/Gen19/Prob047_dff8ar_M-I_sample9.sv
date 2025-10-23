module DFF_AsyncReset_1bit (
    input  wire clk,
    input  wire areset,    // Asynchronous active-high reset
    input  wire d,
    output reg  q
);
    // synthesis async_set_reset "areset" // Suggest to synthesis tool async reset recognition
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            q <= 1'b0; // async reset output to zero
        end else begin
            q <= d;
        end
    end
endmodule

module TopModule (
    input  wire        clk,
    input  wire        areset,
    input  wire [7:0]  d,
    output wire [7:0]  q
);

    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : gen_dffs
            DFF_AsyncReset_1bit dff_inst (
                .clk(clk),
                .areset(areset),
                .d(d[i]),
                .q(q[i])
            );
        end
    endgenerate

endmodule