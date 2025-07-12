module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    input  e,
    output [24:0] out
);

reg [4:0] signal_map [4:0];
reg [24:0] out_map;

always @(*) begin
    signal_map[0] = a;
    signal_map[1] = b;
    signal_map[2] = c;
    signal_map[3] = d;
    signal_map[4] = e;
    
    out_map = 25'd0;
    for (int i = 0; i < 5; i++) begin
        for (int j = 0; j < 5; j++) begin
            out_map[i*5 + j] = ~(signal_map[i] ^ signal_map[j]);
        end
    end
    
    out = out_map;
end

endmodule