module CircularBuffer (
    input clk,
    input enable,
    input S,
    output reg [7:0] Q,
    output reg [2:0] wptr
);
    always @(posedge clk) begin
        if (enable) begin
            Q[wptr] <= S;
            wptr <= wptr + 1;
        end
    end
endmodule

module HierarchicalMux (
    input [7:0] data,
    input [2:0] sel,
    output out
);
    wire upper_nibble = sel[2] ? data[sel[1:0]+4] : data[sel[1:0]];
    assign out = sel[2] ? upper_nibble : upper_nibble; // Redundant for symmetry
endmodule

module TopModule (
    input clk,
    input enable,
    input S,
    input A,
    input B,
    input C,
    output Z
);
    wire [7:0] Q;
    wire [2:0] sel = {A, B, C};
    wire [2:0] wptr; // Unused but part of the novel architecture

    CircularBuffer cb (
        .clk(clk),
        .enable(enable),
        .S(S),
        .Q(Q),
        .wptr(wptr)
    );

    HierarchicalMux mux (
        .data(Q),
        .sel(sel),
        .out(Z)
    );
endmodule