module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out_sop,
    output out_pos
);

    // Pattern detectors for SOP
    wire detect_2, detect_7, detect_15;
    
    assign detect_2 = ~a & ~b & c & ~d;  // 0010
    assign detect_7 = ~a & b & c & d;    // 0111
    assign detect_15 = a & b & c & d;    // 1111
    
    assign out_sop = detect_2 | detect_7 | detect_15;
    
    // Pattern avoiders for POS (inverted)
    wire avoid_0, avoid_1, avoid_4, avoid_5, avoid_6;
    wire avoid_9, avoid_10, avoid_13, avoid_14;
    
    assign avoid_0 = ~(~a & ~b & ~c & ~d);  // 0000
    assign avoid_1 = ~(~a & ~b & ~c & d);   // 0001
    assign avoid_4 = ~(~a & b & ~c & ~d);   // 0100
    assign avoid_5 = ~(~a & b & ~c & d);    // 0101
    assign avoid_6 = ~(~a & b & c & ~d);    // 0110
    assign avoid_9 = ~(a & ~b & ~c & d);    // 1001
    assign avoid_10 = ~(a & ~b & c & ~d);   // 1010
    assign avoid_13 = ~(a & b & ~c & d);    // 1101
    assign avoid_14 = ~(a & b & c & ~d);     // 1110
    
    assign out_pos = avoid_0 & avoid_1 & avoid_4 & avoid_5 & 
                    avoid_6 & avoid_9 & avoid_10 & avoid_13 & avoid_14;

endmodule