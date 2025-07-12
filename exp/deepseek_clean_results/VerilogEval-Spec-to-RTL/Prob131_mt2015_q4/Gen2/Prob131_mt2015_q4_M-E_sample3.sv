module ModuleA(
    input x,
    input y,
    output z
);
    assign z = (x ^ y) & x;
endmodule

module ModuleB(
    input x,
    input y,
    output reg z
);
    always @(*) begin
        case ({x,y})
            2'b00: z = 1'b1;
            2'b01: z = 1'b0;
            2'b10: z = 1'b0;
            2'b11: z = 1'b1;
        endcase
    end
endmodule

module TopModule(
    input clk,
    input x,
    input y,
    output reg z
);
    reg phase;
    wire a_out, b_out;
    reg or_reg, and_reg;
    
    // Single instances
    ModuleA A(.x(x), .y(y), .z(a_out));
    ModuleB B(.x(x), .y(y), .z(b_out));
    
    always @(posedge clk) begin
        if (~phase) begin
            // First phase: compute OR and AND terms
            or_reg <= a_out | b_out;
            and_reg <= a_out & b_out;
            phase <= 1'b1;
        end
        else begin
            // Second phase: compute final XOR
            z <= or_reg ^ and_reg;
            phase <= 1'b0;
        end
    end
endmodule