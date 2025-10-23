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

    wire q_pos;
    wire q_neg;

    // Instantiate positive edge triggered FF
    PosEdgeFF u_pos_ff (
        .clk(clk),
        .d(d),
        .q(q_pos)
    );

    // Instantiate negative edge triggered FF
    NegEdgeFF u_neg_ff (
        .clk(clk),
        .d(d),
        .q(q_neg)
    );

    // Mux between posedge and negedge FF outputs based on clock level
    always @* begin
        case (clk)
            1'b0: q = q_neg;
            1'b1: q = q_pos;
            default: q = 1'bx; // Defensive, though clk is 1-bit
        endcase
    end

endmodule