module TopModule (
    input a,
    input b,
    input sel_b1,
    input sel_b2,
    output out_assign,
    output out_always
);
    // Priority encoded selection (sel_b2 has higher priority)
    wire [1:0] select = {sel_b2, sel_b1};
    
    // Assign-based implementation using bitwise operations
    assign out_assign = (a & ~(|select)) | (b & |select);
    
    // Case-based implementation for clarity
    always @(*) begin
        case (select)
            2'b00: out_always = a;
            2'b01: out_always = a;  // sel_b1 alone doesn't select b
            2'b10: out_always = b;  // sel_b2 alone selects b
            2'b11: out_always = b;  // both select b
        endcase
    end
endmodule