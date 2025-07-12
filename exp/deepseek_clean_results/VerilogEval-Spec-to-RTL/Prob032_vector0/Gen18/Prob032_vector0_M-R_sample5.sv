module TopModule (
    input [2:0] vec,
    output reg [2:0] outv,
    output reg o2, o1, o0
);
    
    always_comb begin
        // Vector output assignment
        outv = vec;
        
        // Individual bit outputs
        {o2, o1, o0} = vec;
    end

endmodule