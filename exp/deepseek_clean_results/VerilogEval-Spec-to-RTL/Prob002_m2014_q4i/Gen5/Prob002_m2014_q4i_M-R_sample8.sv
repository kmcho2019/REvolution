// Alternative 1: Using always block
module TopModule (
    output reg out
);
    always @(*) begin
        out = 1'b0;
    end
endmodule

// Alternative 2: Using initialized wire
module TopModule (
    output out
);
    wire out = 1'b0;
endmodule