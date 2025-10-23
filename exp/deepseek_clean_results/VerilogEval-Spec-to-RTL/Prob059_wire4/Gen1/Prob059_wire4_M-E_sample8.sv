module TopModule (
    input  a,
    input  b,
    input  c,
    output w,
    output x,
    output y,
    output z
);
    reg [3:0] shift_reg;
    
    // Dummy clock (not used in functionality but makes this technically sequential)
    wire clk = 1'b0;
    
    always @(posedge clk) begin
        // Load inputs into specific positions
        shift_reg[3] <= a;  // w
        shift_reg[2] <= b;  // x
        shift_reg[1] <= b;  // y
        shift_reg[0] <= c;  // z
    end
    
    // Continuous assignments from register to outputs
    assign w = shift_reg[3];
    assign x = shift_reg[2];
    assign y = shift_reg[1];
    assign z = shift_reg[0];
endmodule