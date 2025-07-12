module TopModule (
    input [2:0] vec,
    output [2:0] outv,
    output o2,
    output o1,
    output o0
);

    reg [2:0] shift_reg;
    reg load = 1'b1;  // Internal control signal
    
    always @(*) begin
        if (load) begin
            shift_reg = vec;  // Parallel load
        end
    end
    
    // Parallel output
    assign outv = shift_reg;
    
    // Serial outputs (though accessed in parallel)
    assign o2 = shift_reg[2];
    assign o1 = shift_reg[1];
    assign o0 = shift_reg[0];

endmodule