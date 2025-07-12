module edge_detect (
    input clk,
    input rst_n,
    input a,
    output rise,
    output down
);

    wire a_prev;
    
    // D flip-flop with asynchronous reset
    DFF dff_inst (
        .D(a),
        .CLK(clk),
        .RST_N(rst_n),
        .Q(a_prev)
    );
    
    // Edge detection logic (combinational)
    assign rise = a & ~a_prev;
    assign down = ~a & a_prev;

endmodule

// D flip-flop primitive with asynchronous reset
module DFF (
    input D,
    input CLK,
    input RST_N,
    output reg Q
);
    always @(posedge CLK or negedge RST_N) begin
        if (!RST_N)
            Q <= 1'b0;
        else
            Q <= D;
    end
endmodule