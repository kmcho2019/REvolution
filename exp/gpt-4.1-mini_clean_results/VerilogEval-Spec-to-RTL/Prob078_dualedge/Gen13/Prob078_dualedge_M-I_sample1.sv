module PosEdgeFF (
    input wire clk,
    input wire d,
    output reg q
);
    always @(posedge clk) begin
        q <= d;
    end
endmodule

module NegEdgeFF (
    input wire clk,
    input wire d,
    output reg q
);
    always @(negedge clk) begin
        q <= d;
    end
endmodule

module TopModule (
    input wire clk,
    input wire d,
    output reg q
);
    wire q_posedge, q_negedge;
    reg mux_out;

    // Instantiate FFs triggered on opposite edges
    PosEdgeFF u_posedge_ff (
        .clk(clk),
        .d(d),
        .q(q_posedge)
    );

    NegEdgeFF u_negedge_ff (
        .clk(clk),
        .d(d),
        .q(q_negedge)
    );

    // Combinational mux selecting output based on clock level
    always @(*) begin
        if (clk)
            mux_out = q_posedge;
        else
            mux_out = q_negedge;
    end

    // Register mux output to reduce glitches and improve timing/power
    always @(posedge clk) begin
        q <= mux_out;
    end
endmodule