module TopModule (
    input clk,
    input in,
    output out
);

    reg dff_out;
    
    // XOR of input and DFF output
    wire xor_out = in ^ dff_out;
    
    // Positive edge-triggered DFF
    always @(posedge clk) begin
        dff_out <= xor_out;
    end
    
    assign out = dff_out;

endmodule