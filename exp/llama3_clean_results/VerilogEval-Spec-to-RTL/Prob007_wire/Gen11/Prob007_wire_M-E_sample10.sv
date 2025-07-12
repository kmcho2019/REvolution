module TopModule(
    input  in,
    output out
);
    
    reg out_reg;
    
    // Creating a D Flip-Flop with clock tied high
    always @(posedge 1'b1) begin
        out_reg <= in;
    end
    
    // Assign the output of the DFF to the output port
    assign out = out_reg;

endmodule