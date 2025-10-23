module TopModule (
    input [254:0] in,
    output [7:0] out
);

    // Define a function to count the number of '1's in a byte
    function [7:0] count_ones;
        input [7:0] x;
        begin
            count_ones = (x[0] + x[1] + x[2] + x[3] + x[4] + x[5] + x[6] + x[7]);
        end
    endfunction

    // Define a reg to hold the count
    reg [7:0] count;

    // Initialize the count to 0
    initial count = 0;

    // Count the number of '1's in each byte and add up the counts
    always @(*) begin
        count = 0;
        for (int i = 0; i < 32; i++) begin
            if (i == 31) begin
                // Handle the case where the input vector is not a multiple of 8 bits
                count = count + (in[7:0] === 8'b1 ? 1 : 
                                 in[6:0] === 7'b1 ? 1 : 
                                 in[5:0] === 6'b1 ? 1 : 
                                 in[4:0] === 5'b1 ? 1 : 
                                 in[3:0] === 4'b1 ? 1 : 
                                 in[2:0] === 3'b1 ? 1 : 
                                 in[1:0] === 2'b1 ? 1 : 
                                 in[0] === 1'b1 ? 1 : 0);
            end else begin
                count = count + count_ones(in[(i*8)+7:(i*8)]);
            end
        end
        out = count;
    end

endmodule