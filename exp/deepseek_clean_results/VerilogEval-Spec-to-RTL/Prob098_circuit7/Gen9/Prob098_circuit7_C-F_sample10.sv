module TopModule(
    input clk,
    input a,
    output q
);
    reg q_reg = 1'b1;  // Initialize to 1 as per waveform
    
    // Output assignment
    assign q = q_reg;
    
    // Sequential logic with clear behavior
    always @(posedge clk) begin
        q_reg <= a ? 1'b0 : 1'b1;
    end
endmodule