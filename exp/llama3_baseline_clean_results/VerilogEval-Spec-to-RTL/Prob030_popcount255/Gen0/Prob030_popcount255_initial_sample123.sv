module TopModule(
    input  [254:0] in,
    output [7:0] out
);

    // Define the population count function for an 8-bit input
    function [7:0] popcount8(input [7:0] x);
        reg [7:0] count;
        integer i;
        begin
            count = 8'd0;
            for (i = 0; i < 8; i = i + 1) begin
                if (x[i]) begin
                    count = count + 1'b1;
                end
            end
            return count;
        end
    endfunction

    // Define the population count function for a 255-bit input
    reg [7:0] count;
    reg [7:0] counts [31:0];
    integer i;

    always @(*) begin
        count = 8'd0;
        for (i = 0; i < 32; i = i + 1) begin
            // Slice the input into 8-bit groups and count '1's in each group
            counts[i] = popcount8(in[(i*8+7):(i*8)]);
            // Sum up the counts from all groups
            count = count + counts[i];
        end
        // Handle the case where the input is not a multiple of 8 bits
        // Since the input is 255 bits, the last 7 bits are handled separately
        count = count + popcount8({8{in[254]}});
        out = count[7:0];
    end

endmodule