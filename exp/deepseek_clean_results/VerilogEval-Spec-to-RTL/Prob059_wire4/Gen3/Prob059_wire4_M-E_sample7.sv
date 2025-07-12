module TopModule (
    input a,
    input b,
    input c,
    output w,
    output x,
    output y,
    output z
);
    localparam W_REP = 1;
    localparam X_REP = 1;
    localparam Y_REP = 1;
    localparam Z_REP = 1;
    
    assign w = {W_REP{a}};
    assign x = {X_REP{b}};
    assign y = {Y_REP{b}};
    assign z = {Z_REP{c}};
endmodule