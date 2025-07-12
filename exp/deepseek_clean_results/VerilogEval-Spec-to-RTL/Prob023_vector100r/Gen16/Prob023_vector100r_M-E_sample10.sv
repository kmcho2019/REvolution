module TopModule (
    input  [99:0] in,
    output [99:0] out
);

logic [99:0] reversed;

always_comb begin
    for (int i = 0; i < 100; i++) begin
        reversed[i] = in[99-i];
    end
end

assign out = reversed;

endmodule