module TopModule(
    input [99:0] in,
    output [99:0] out_both,
    output [99:0] out_any,
    output [99:0] out_different
);

integer i;
always @(*)
begin
    for(i = 0; i <= 99; i++)
    begin
        // out_both: Check if current bit and its neighbor to the left are both '1'
        if(i == 99)
            out_both[i] = 0;
        else
            out_both[i] = in[i] & in[i+1];
        
        // out_any: Check if current bit or its neighbor to the right is '1'
        if(i == 0)
            out_any[i] = 0;
        else
            out_any[i] = in[i] | in[i-1];
        
        // out_different: Check if current bit is different from its neighbor to the left
        if(i == 99)
            out_different[i] = in[i] ^ in[0];
        else
            out_different[i] = in[i] ^ in[i+1];
    end
end

endmodule