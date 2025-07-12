module TopModule (
    input [2:0] vec,
    output [2:0] outv,
    output o2, o1, o0
);

    // Vector output assignment (clean and concise)
    assign outv = vec;
    
    // Individual bit outputs (explicit and readable)
    assign o2 = vec[2];
    assign o1 = vec[1];
    assign o0 = vec[0];

endmodule