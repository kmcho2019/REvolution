module ModuleA(x, y, z);
    input x, y;
    output z;
    assign z = (x ^ y) & x;
endmodule

module ModuleB(x, y, z);
    input x, y;
    output z;
    reg z;
    always @(x or y) begin
        case ({x, y})
            2'b00: z = 1'b1;
            2'b01: z = 1'b0;
            2'b10: z = 1'b0;
            2'b11: z = 1'b1;
        endcase
    end
endmodule

module TopLevel(x, y, z);
    input x, y;
    output z;
    wire a1, a2, b1, b2, or_out, and_out;
    
    ModuleA u_a1(x, y, a1);
    ModuleB u_b1(x, y, b1);
    ModuleA u_a2(x, y, a2);
    ModuleB u_b2(x, y, b2);
    
    assign or_out = a1 | b1;
    assign and_out = a2 & b2;
    assign z = or_out ^ and_out;
endmodule