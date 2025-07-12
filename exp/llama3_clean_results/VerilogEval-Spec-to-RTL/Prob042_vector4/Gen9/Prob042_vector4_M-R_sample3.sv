module TopModule(
    input  [7:0] in,
    output [31:0] out
);
    // Using conditional operator
    assign out = (in[7] == 1'b1) ? {24{1'b1}, in} : {24{1'b0}, in};
    
    // Alternatively, using always block (not recommended for this simple case)
    // always @(*) begin
    //     if (in[7] == 1'b1) begin
    //         out = {24{1'b1}, in};
    //     end else begin
    //         out = {24{1'b0}, in};
    //     end
    // end
    
    // Original code for reference
    // assign out = { {24{in[7]}}, in };
endmodule