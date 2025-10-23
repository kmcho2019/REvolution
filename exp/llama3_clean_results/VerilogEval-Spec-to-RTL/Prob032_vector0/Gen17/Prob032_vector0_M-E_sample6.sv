module TopModule(
    input  [2:0] vec,
    output [2:0] outv,
    output o2,
    output o1,
    output o0
);

integer i;

always @(*) begin
    outv = vec;
    o2 = vec[2];
    o1 = vec[1];
    o0 = vec[0];
    
    // Alternative way using case statement
    // case (vec)
    //     3'b000: begin outv = 3'b000; o2 = 1'b0; o1 = 1'b0; o0 = 1'b0; end
    //     3'b001: begin outv = 3'b001; o2 = 1'b0; o1 = 1'b0; o0 = 1'b1; end
    //     3'b010: begin outv = 3'b010; o2 = 1'b0; o1 = 1'b1; o0 = 1'b0; end
    //     3'b011: begin outv = 3'b011; o2 = 1'b0; o1 = 1'b1; o0 = 1'b1; end
    //     3'b100: begin outv = 3'b100; o2 = 1'b1; o1 = 1'b0; o0 = 1'b0; end
    //     3'b101: begin outv = 3'b101; o2 = 1'b1; o1 = 1'b0; o0 = 1'b1; end
    //     3'b110: begin outv = 3'b110; o2 = 1'b1; o1 = 1'b1; o0 = 1'b0; end
    //     3'b111: begin outv = 3'b111; o2 = 1'b1; o1 = 1'b1; o0 = 1'b1; end
    // endcase
end

endmodule