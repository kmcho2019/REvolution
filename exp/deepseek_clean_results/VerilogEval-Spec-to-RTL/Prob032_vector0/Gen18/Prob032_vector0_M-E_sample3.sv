module TopModule (
    input [2:0] vec,
    output reg [2:0] outv,
    output reg o2, o1, o0
);
    
    // Shadow register implementation
    always @(*) begin
        outv = vec;      // Parallel capture of entire vector
        o2 = vec[2];     // Individual bit shadowing
        o1 = vec[1];
        o0 = vec[0];
    end

endmodule