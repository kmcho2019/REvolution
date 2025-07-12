module TopModule (
    input  a,
    input  b,
    input  c,
    output w,
    output x,
    output y,
    output z
);
    // 3-bit routing register
    reg [2:0] route_reg;
    
    always @(*) begin
        route_reg[0] = a;
        route_reg[1] = b;
        route_reg[2] = c;
    end
    
    // Output taps from the routing register
    assign w = route_reg[0];  // a
    assign x = route_reg[1];  // b
    assign y = route_reg[1];  // b
    assign z = route_reg[2];  // c
endmodule