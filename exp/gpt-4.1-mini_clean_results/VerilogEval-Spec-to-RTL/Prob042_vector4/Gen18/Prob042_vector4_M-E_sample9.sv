module TopModule (
    input  [7:0] in,
    output reg [31:0] out
);

    always @(*) begin
        if (in[7] == 1'b1) begin
            // Sign bit is 1: fill upper bits with 1's
            out = {24'hFFFFFF, in};
        end else begin
            // Sign bit is 0: fill upper bits with 0's
            out = {24'h000000, in};
        end
    end

endmodule