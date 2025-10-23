module TopModule(
    input  logic [2:0] vec,
    output logic [2:0] outv,
    output logic o2,
    output logic o1,
    output logic o0
    );
    
    assign {o2, o1, o0} = vec;
    assign outv = vec;

endmodule