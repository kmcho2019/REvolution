module TopModule(
    input [3:0] x,
    output logic f
);

assign f = (x[3] & (x[1] | x[2])) | ((~x[3]) & x[1] & x[2]);

// Alternatively, for explicitness and to cover all conditions precisely:
// assign f = (x[3] & (x[1] | x[2])) | 
//           (~x[3] & x[1] & x[2]);

// Considering the feedback, let's ensure all conditions are met:
always @(*) begin
    if ((x[3] == 1'b1 && (x[1] == 1'b1 || x[2] == 1'b1)) || 
        (x[3] == 1'b0 && x[1] == 1'b1 && x[2] == 1'b1)) begin
        f = 1'b1;
    end else begin
        // For all other conditions, f should be 0 or don't care.
        // Given the Karnaugh map, we can simplify this to just assign 0
        // for conditions not explicitly setting f to 1.
        f = 1'b0;
    end
end

endmodule