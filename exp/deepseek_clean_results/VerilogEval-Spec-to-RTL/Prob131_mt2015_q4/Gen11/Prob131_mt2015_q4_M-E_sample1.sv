module ModuleA(
    input x,
    input y,
    output reg z
);
    always @(*) begin
        z = (x ^ y) & x;
    end
endmodule

module ModuleB(
    input x,
    input y,
    output reg z
);
    always @(*) begin
        z = ~(x ^ y);
    end
endmodule

module TopModule(
    input clk,
    input x,
    input y,
    output reg z
);
    reg [1:0] counter = 0;
    wire a_out, b_out;
    reg a1_reg, b1_reg, a2_reg, b2_reg;
    wire or_out, and_out;
    
    // Single instances of each module type
    ModuleA A(.x(x), .y(y), .z(a_out));
    ModuleB B(.x(x), .y(y), .z(b_out));
    
    // Time-multiplexed operation
    always @(posedge clk) begin
        case(counter)
            2'b00: a1_reg <= a_out;      // Store A1 result
            2'b01: b1_reg <= b_out;      // Store B1 result
            2'b10: a2_reg <= a_out;     // Store A2 result
            2'b11: b2_reg <= b_out;      // Store B2 result
        endcase
        counter <= counter + 1;
    end
    
    // Combinational outputs
    assign or_out = a1_reg | b1_reg;
    assign and_out = a2_reg & b2_reg;
    
    // Final output registered
    always @(posedge clk) begin
        z <= or_out ^ and_out;
    end
endmodule