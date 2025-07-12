module TopModule (
    input [2:0] vec,
    output reg [2:0] outv,
    output reg o2,
    output reg o1,
    output reg o0
);

    always @(*) begin
        // Vector output assignment
        outv = vec;
        
        // Individual bit assignments
        o0 = vec[0];
        o1 = vec[1];
        o2 = vec[2];
    end

endmodule