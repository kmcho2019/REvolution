module TopModule (
    input [7:0] in,
    output reg [7:0] out
);

    reg [7:0] temp;
    integer i;

    always @(*) begin
        temp = in;  // Copy input to temporary register
        out = 0;    // Initialize output
        
        for (i = 0; i < 8; i = i + 1) begin
            out = out << 1;          // Shift output left
            out[0] = temp[7];        // Take MSB from temp
            temp = temp << 1;        // Shift temp left
        end
    end

endmodule