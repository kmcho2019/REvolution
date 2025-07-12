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
    reg q_mux;

    // Sample input on rising edge
    PosEdgeFF u_posedge_ff (
        .clk(clk),
        .d(d),
        .q(q_posedge)
    );

    // Sample input on falling edge
    NegEdgeFF u_negedge_ff (
        .clk(clk),
        .d(d),
        .q(q_negedge)
    );

    // Combinational mux selecting based on clock level
    always @(*) begin
        if (clk)
            q_mux = q_posedge;
        else
            q_mux = q_negedge;
    end

    // Register output q on rising edge to avoid glitches
    always @(posedge clk) begin
        q <= q_mux;
    end
endmodule