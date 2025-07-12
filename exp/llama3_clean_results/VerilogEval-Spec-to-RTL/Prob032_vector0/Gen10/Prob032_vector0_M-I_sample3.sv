module TopModule(
    input clk, // Assuming a clock signal for registration
    input [2:0] vec,
    output [2:0] outv,
    output o2,
    output o1,
    output o0
    );
    
    reg [2:0] vec_reg; // Registered input vector
    
    always @(posedge clk) begin
        vec_reg <= vec;
    end
    
    assign outv = vec_reg;
    assign o2 = vec_reg[2];
    assign o1 = vec_reg[1];
    assign o0 = vec_reg[0];

endmodule