module TopModule (
    input [7:0] a,
    input [7:0] b,
    input [7:0] c,
    input [7:0] d,
    output [7:0] min
);

    reg [7:0] min_val;
    
    always @(*) begin
        // First level comparisons
        reg [7:0] min_ab = (a < b) ? a : b;
        reg [7:0] min_cd = (c < d) ? c : d;
        
        // Final comparison
        min_val = (min_ab < min_cd) ? min_ab : min_cd;
    end
    
    assign min = min_val;

endmodule