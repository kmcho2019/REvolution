module TopModule(
    input  [2:0] a,
    output [15:0] q
);

// Define the output values as parameters for easy modification
parameter OUTPUT_0 = 16'h1232;
parameter OUTPUT_1 = 16'haee0;
parameter OUTPUT_2 = 16'h27d4;
parameter OUTPUT_3 = 16'h5a0e;
parameter OUTPUT_4 = 16'h2066;
parameter OUTPUT_5 = 16'h64ce;
parameter OUTPUT_6 = 16'hc526;
parameter OUTPUT_7 = 16'h2f19;

// Use an always block with a case statement to implement the required mapping
always @(*) begin
    case (a)
        3'b000: q = OUTPUT_0;
        3'b001: q = OUTPUT_1;
        3'b010: q = OUTPUT_2;
        3'b011: q = OUTPUT_3;
        3'b100: q = OUTPUT_4;
        3'b101: q = OUTPUT_5;
        3'b110: q = OUTPUT_6;
        3'b111: q = OUTPUT_7;
        default: q = 16'h0000; // Default case, though not expected to occur
    endcase
end

endmodule