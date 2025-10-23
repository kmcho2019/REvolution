module DFF_Vector_AsyncReset #(parameter WIDTH = 8) (
    input                  clk,
    input                  areset,
    input  [WIDTH-1:0]     d,
    output reg [WIDTH-1:0] q
);

    wire reset_active = areset;

    always @(posedge clk or posedge reset_active) begin
        if (reset_active)
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
    DFF_Vector_AsyncReset #(8) dff_vec_inst (
        .clk(clk),
        .areset(areset),
        .d(d),
        .q(q)
    );
endmodule