module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out_sop,
    output out_pos
);

    // Minimal SOP implementation
    // out_sop = a'b'cd' + a'bcd + abcd
    assign out_sop = (~a & ~b & c & ~d) | (~a & b & c & d) | (a & b & c & d);

    // Minimal POS implementation
    // out_pos = (a+b+c+d)(a+b+c+d')(a+b'+c+d)(a+b'+c+d')(a+b'+c'+d)
    //          (a'+b+c+d')(a'+b+c'+d)(a'+b+c'+d')(a'+b'+c+d')
    assign out_pos = (a | b | c | d) & 
                    (a | b | c | ~d) & 
                    (a | ~b | c | d) & 
                    (a | ~b | c | ~d) & 
                    (a | ~b | ~c | d) & 
                    (~a | b | c | ~d) & 
                    (~a | b | ~c | d) & 
                    (~a | b | ~c | ~d) & 
                    (~a | ~b | c | ~d);

endmodule