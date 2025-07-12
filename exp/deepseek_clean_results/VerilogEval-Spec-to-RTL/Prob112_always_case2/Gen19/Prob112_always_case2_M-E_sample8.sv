module TopModule (
    input [3:0] in,
    output reg [1:0] pos
);

always_comb begin
    // First level: Check if any bits in upper half are set
    if (in[3] | in[2]) begin
        // Second level: Check which upper bit is set (priority to higher bit)
        if (in[3]) pos = 2'b11;
        else pos = 2'b10;
    end
    else begin
        // Check lower half only if upper half is all zeros
        if (in[1] | in[0]) begin
            // Second level: Check which lower bit is set (priority to higher bit)
            if (in[1]) pos = 2'b01;
            else pos = 2'b00;
        end
        else begin
            // All zeros case
            pos = 2'b00;
        end
    end
end

endmodule