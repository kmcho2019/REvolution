module TopModule(
    input  [2:0] vec,
    output reg [2:0] outv,
    output reg       o2,
    output reg       o1,
    output reg       o0
);

always @(*) begin
    outv = vec;     // Pass entire vector
    o0   = vec[0];  // LSB bit
    o1   = vec[1];  // Middle bit
    o2   = vec[2];  // MSB bit
end

endmodule