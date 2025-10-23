module TopModule(
    input  [7:0] in,
    output reg [31:0] out
);
    always @(*) begin
        if (in[7] == 1'b1) begin
            // Sign bit is 1: upper bits all ones
            out = {24'hFFFFFF, in};
        end else begin
            // Sign bit is 0: upper bits all zeros
            out = {24'h000000, in};
        end
    end
endmodule