module TopModule (
    input clk,
    input in,
    output out
);

    reg feedback_reg;
    wire xor_out;
    
    assign xor_out = in ^ feedback_reg;
    assign out = feedback_reg;
    
    always @(posedge clk) begin
        feedback_reg <= xor_out;
    end

endmodule