module TopModule(
    input  logic [2:0] vec,
    output logic [2:0] outv,
    output logic o2,
    output logic o1,
    output logic o0
    );
    
    // Using always block for combinational logic
    always_comb begin
        outv = vec;
        o2 = vec[2];
        o1 = vec[1];
        o0 = vec[0];
    end

endmodule