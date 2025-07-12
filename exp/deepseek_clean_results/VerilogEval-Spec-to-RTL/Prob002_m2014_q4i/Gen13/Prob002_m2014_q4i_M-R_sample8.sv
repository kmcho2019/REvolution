// Option 1: Using continuous assignment with explicit wire
module TopModule(output wire out);
    assign out = 1'b0;
endmodule

// Option 2: Using procedural always block
module TopModule(output reg out);
    always @(*) begin
        out = 1'b0;
    end
endmodule

// Option 3: Using parameter
module TopModule(output out);
    parameter ZERO = 1'b0;
    assign out = ZERO;
endmodule