module TopModule (
    input  [2:0] in,
    output reg [1:0] out
);
    // Combinational population count of 3 bits using sum inside always block
    always @(*) begin
        out = in[0] + in[1] + in[2];
    end
endmodule