module TopModule(
    input  [1023:0] in,
    input  [7:0] sel,
    output [3:0] out
);

    reg [9:0] offset; // To hold the offset calculated from sel
    reg [3:0] temp_out; // Temporary output register

    always @(*) begin
        offset = {2'b0, sel} << 2; // Calculate offset, effectively multiplying sel by 4
        temp_out = in[offset +: 4]; // Extract 4 bits starting from the calculated offset
    end

    assign out = temp_out; // Assign the extracted bits to the output

endmodule