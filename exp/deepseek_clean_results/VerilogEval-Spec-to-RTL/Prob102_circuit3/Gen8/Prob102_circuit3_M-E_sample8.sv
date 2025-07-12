module TopModule (
    input a,
    input b,
    input c,
    input d,
    output q
);
    wire [1:0] ab_encoded;
    wire [1:0] cd_encoded;
    
    // Priority encoder for a,b (b has higher priority)
    assign ab_encoded = b ? 2'b10 : (a ? 2'b01 : 2'b00);
    
    // Priority encoder for c,d (d has higher priority)
    assign cd_encoded = d ? 2'b10 : (c ? 2'b01 : 2'b00);
    
    // Output is 1 when both encoders have non-zero outputs
    assign q = (|ab_encoded) & (|cd_encoded);
endmodule