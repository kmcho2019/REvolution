module edge_detect (
    input clk,
    input rst_n,
    input a,
    output rise,
    output down
);

    wire a_prev;
    
    // Instantiate a D flip-flop directly for the delayed signal
    DFF dff_inst (
        .D(a),
        .CLK(clk),
        .Q(a_prev)
    );
    
    // Edge detection logic
    assign rise = a & ~a_prev;
    assign down = ~a & a_prev;

endmodule

// D flip-flop primitive
module DFF (
    input D,
    input CLK,
    output reg Q
);
    always @(posedge CLK) begin
        Q <= D;
    end
endmodule