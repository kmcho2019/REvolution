module TopModule (
    input [2:0] vec,
    output [2:0] outv,
    output o2,
    output o1,
    output o0
);

    reg [2:0] shift_reg;
    wire clk;  // Assuming an internal clock for demonstration
    
    // Initialize with input vector
    initial begin
        shift_reg = vec;
    end
    
    // Continuous rotation (though functionally equivalent to direct assignment)
    always @(posedge clk) begin
        shift_reg <= {shift_reg[0], shift_reg[2:1]};
    end
    
    // Output assignments
    assign outv = shift_reg;
    assign {o2, o1, o0} = shift_reg;

endmodule