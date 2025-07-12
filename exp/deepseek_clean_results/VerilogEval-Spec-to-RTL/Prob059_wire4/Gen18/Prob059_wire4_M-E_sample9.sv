module TopModule (
    input  a,
    input  b,
    input  c,
    output w,
    output x,
    output y,
    output z
);
    // Configuration parameters (could be made module parameters)
    localparam [1:0] W_SEL = 2'b00; // Select a (00)
    localparam [1:0] X_SEL = 2'b01; // Select b (01)
    localparam [1:0] Y_SEL = 2'b01; // Select b (01)
    localparam [1:0] Z_SEL = 2'b10; // Select c (10)

    // Input bus
    wire [2:0] inputs = {c, b, a}; // Ordered 2:0 for selection
    
    // Crossbar implementation
    assign w = inputs[W_SEL];
    assign x = inputs[X_SEL];
    assign y = inputs[Y_SEL];
    assign z = inputs[Z_SEL];
endmodule