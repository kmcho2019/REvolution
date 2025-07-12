module TopModule (
    input  [7:0] in,
    output reg [31:0] out
);

    always @* begin
        if (in[7] == 1'b1) begin
            out[31:8] = 24'hFFFFFF; // replicate sign bit '1' 24 times
        end else begin
            out[31:8] = 24'h000000; // replicate sign bit '0' 24 times
        end
        out[7:0] = in;
    end

endmodule