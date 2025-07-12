module TopModule (
    input clk,
    input in,
    output out
);

    wire feedback;
    wire xor_out = in ^ out;
    
    // Clock-gated feedback path
    assign feedback = clk ? xor_out : out;
    
    // Output register with clock-controlled update
    assign out = feedback;

endmodule