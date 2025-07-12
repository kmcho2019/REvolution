module TopModule (
    input clk,
    input areset,
    input j,
    input k,
    output out
);

    // State encoding
    wire state;
    wire next_state;
    localparam OFF = 1'b0;
    localparam ON  = 1'b1;

    // DFF primitive for state storage
    DFF state_reg (
        .D(next_state),
        .CLK(clk),
        .RST(areset),
        .Q(state)
    );

    // Combinational next-state logic
    assign next_state = areset ? OFF : 
                       (state == OFF) ? (j ? ON : OFF) :
                       (state == ON)  ? (k ? OFF : ON) : OFF;

    // Output logic - pure combinational
    assign out = state;

endmodule

// Basic D flip-flop primitive
module DFF (
    input D,
    input CLK,
    input RST,
    output reg Q
);
    always @(posedge CLK or posedge RST) begin
        if (RST)
            Q <= 1'b0;
        else
            Q <= D;
    end
endmodule