module TopModule(
    input [2:0] vec,
    output [2:0] outv,
    output o2,
    output o1,
    output o0
    );
    
    wire [2:0] internal_vec;
    assign internal_vec = vec;
    assign outv = internal_vec;
    assign o2 = internal_vec[2];
    assign o1 = internal_vec[1];
    assign o0 = internal_vec[0];

endmodule