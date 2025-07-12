module TopModule(
    input clk,
    input a,
    output reg q
);

// Initialization
initial q = 1'b1;

// Sequential Logic
always @(posedge clk) begin
    // Combinational Logic: Invert 'a'
    reg inverted_a;
    assign inverted_a = ~a;
    
    // Update 'q' with the inverted value of 'a'
    q <= inverted_a;
end

endmodule