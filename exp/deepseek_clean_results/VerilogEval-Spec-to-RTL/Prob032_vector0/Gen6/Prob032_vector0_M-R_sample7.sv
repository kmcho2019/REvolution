module TopModule (
    input [2:0] vec,
    output reg [2:0] outv,
    output reg o2, o1, o0
);

    always @(*) begin
        // Assign the entire vector
        outv = vec;
        
        // Split into individual bits
        o2 = vec[2];
        o1 = vec[1];
        o0 = vec[0];
    end

endmodule