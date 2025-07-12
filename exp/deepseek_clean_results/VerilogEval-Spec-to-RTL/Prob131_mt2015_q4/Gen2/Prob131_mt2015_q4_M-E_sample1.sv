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
        z = ~(x ^ y);  // x XNOR y
    end
endmodule

module TopModule(
    input clk,
    input x,
    input y,
    output reg z
);
    reg [1:0] counter;
    reg a_out, b_out;
    reg or_out, and_out;
    
    // Single instances of each module
    ModuleA A(.x(x), .y(y), .z(a_out));
    ModuleB B(.x(x), .y(y), .z(b_out));
    
    always @(posedge clk) begin
        case (counter)
            2'b00: begin
                // First cycle - store first A and B results
                or_out <= a_out | b_out;
                counter <= counter + 1;
            end
            2'b01: begin
                // Second cycle - store second A and B results
                and_out <= a_out & b_out;
                counter <= counter + 1;
            end
            2'b10: begin
                // Third cycle - compute final output
                z <= or_out ^ and_out;
                counter <= 2'b00;
            end
            default: counter <= 2'b00;
        endcase
    end
endmodule