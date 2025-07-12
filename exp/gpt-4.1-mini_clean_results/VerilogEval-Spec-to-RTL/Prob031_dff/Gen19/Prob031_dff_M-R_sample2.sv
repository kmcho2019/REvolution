// D flip-flop with internal state register and continuous output assignment
module DFF (
    input  wire clk,
    input  wire d,
    output wire q
);
    reg state;

    always @(posedge clk) begin
        state = d; // blocking assignment to internal state on clock edge
    end

    assign q = state; // continuous assignment from internal state register
endmodule

// Top-level module instantiates the DFF
module TopModule (
    input  wire clk,
    input  wire d,
    output wire q
);
    DFF dff_inst (
        .clk(clk),
        .d(d),
        .q(q)
    );
endmodule