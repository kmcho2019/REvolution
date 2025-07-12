module TopModule (
    input [7:0] a,
    input [7:0] b,
    input [7:0] c,
    input [7:0] d,
    output [7:0] min
);

    // Combine all inputs into a single vector
    wire [31:0] combined = {a, b, c, d};
    
    // Priority encoder to find the minimum value
    reg [7:0] min_val;
    integer i;
    
    always @(*) begin
        min_val = 8'hFF; // Initialize to maximum value
        for (i = 0; i < 4; i = i + 1) begin
            if (combined[i*8 +: 8] < min_val) begin
                min_val = combined[i*8 +: 8];
            end
        end
    end
    
    assign min = min_val;

endmodule