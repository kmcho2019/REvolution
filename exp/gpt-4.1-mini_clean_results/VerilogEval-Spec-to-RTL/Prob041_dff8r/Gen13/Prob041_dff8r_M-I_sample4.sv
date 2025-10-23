module DFF_sync_reset_vec #(
    parameter WIDTH = 8
) (
    input               clk,
    input               reset,
    input  [WIDTH-1:0]  d,
    output reg [WIDTH-1:0] q
);
    wire en = reset | (d != q); // Enable update only when reset or data changes

    always @(posedge clk) begin
        if (en) begin
            if (reset)
                q <= {WIDTH{1'b0}};
            else
                q <= d;
        end
    end
endmodule

module TopModule (
    input           clk,
    input           reset,
    input  [7:0]    d,
    output [7:0]    q
);
    // Instantiate the 8-bit DFF module with clock enable optimization
    DFF_sync_reset_vec #(.WIDTH(8)) dff_inst (
        .clk(clk),
        .reset(reset),
        .d(d),
        .q(q)
    );
endmodule