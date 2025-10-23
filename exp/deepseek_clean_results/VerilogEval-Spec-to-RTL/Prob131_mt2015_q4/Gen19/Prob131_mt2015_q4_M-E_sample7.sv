module ConfigurableModule(
    input x,
    input y,
    input sel,  // 0 for ModuleA, 1 for ModuleB
    output reg z
);
    always @(*) begin
        if (!sel)
            z = x & ~y;  // ModuleA function
        else
            z = ~(x ^ y); // ModuleB function
    end
endmodule

module TopModule(
    input x,
    input y,
    output z
);
    reg [1:0] state;
    wire [1:0] func_out;
    reg a_out, b_out;
    
    // Configurable module instance
    ConfigurableModule CM1(
        .x(x),
        .y(y),
        .sel(1'b0),  // Always ModuleA
        .z(func_out[0])
    );
    
    ConfigurableModule CM2(
        .x(x),
        .y(y),
        .sel(1'b1),  // Always ModuleB
        .z(func_out[1])
    );
    
    // Combined output logic
    assign z = (func_out[0] | func_out[1]) ^ (func_out[0] & func_out[1]);
    
    // Alternative implementation using arithmetic operators
    // assign z = func_out[0] + func_out[1] == 1;
endmodule