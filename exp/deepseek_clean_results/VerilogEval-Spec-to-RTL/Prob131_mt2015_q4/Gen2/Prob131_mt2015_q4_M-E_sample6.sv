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
    input x,
    input y,
    input clk,      // Added clock for sequential operation
    output reg z
);
    wire a_out, b_out;
    reg [1:0] state;
    reg or_reg, and_reg;
    
    // Single instances of each module
    ModuleA A(.x(x), .y(y), .z(a_out));
    ModuleB B(.x(x), .y(y), .z(b_out));
    
    // State machine to time-multiplex operations
    always @(posedge clk) begin
        case (state)
            2'b00: begin
                or_reg <= a_out | b_out;  // First OR operation
                state <= 2'b01;
            end
            2'b01: begin
                and_reg <= a_out & b_out; // Then AND operation
                state <= 2'b10;
            end
            2'b10: begin
                z <= or_reg ^ and_reg;   // Final XOR operation
                state <= 2'b00;
            end
            default: state <= 2'b00;
        endcase
    end
endmodule