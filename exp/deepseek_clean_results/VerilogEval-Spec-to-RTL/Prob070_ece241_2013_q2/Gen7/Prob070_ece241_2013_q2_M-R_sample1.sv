module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out_sop,
    output out_pos
);

    // Form 4-bit address from inputs
    wire [3:0] addr = {a,b,c,d};

    // SOP implementation - minimal sum of products
    assign out_sop = (addr == 4'd2) | (addr == 4'd7) | (addr == 4'd15);

    // POS implementation - minimal product of sums
    assign out_pos = !((addr == 4'd0) | (addr == 4'd1) | 
                     (addr == 4'd4) | (addr == 4'd5) | 
                     (addr == 4'd6) | (addr == 4'd9) | 
                     (addr == 4'd10) | (addr == 4'd13) | 
                     (addr == 4'd14));

endmodule