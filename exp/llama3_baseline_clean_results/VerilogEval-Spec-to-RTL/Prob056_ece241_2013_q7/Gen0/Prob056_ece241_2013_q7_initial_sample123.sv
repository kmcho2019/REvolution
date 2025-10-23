module TopModule(
    input clk,
    input j,
    input k,
    output reg Q
);

always @ (posedge clk) begin
    if (j == 1'b0 && k == 1'b0) 
        Q <= Q; // Q remains the same
    else if (j == 1'b0 && k == 1'b1) 
        Q <= 1'b0; // Q is reset
    else if (j == 1'b1 && k == 1'b0) 
        Q <= 1'b1; // Q is set
    else if (j == 1'b1 && k == 1'b1) 
        Q <= ~Q; // Q is toggled
end

endmodule