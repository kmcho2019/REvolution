module TopModule(
    input  [254:0] in,
    output [7:0] out
);

reg [7:0] count;

always @(*)
begin
    reg [4:0] count_17bit [14:0];
    reg [7:0] sum;

    // Count '1's in each 17-bit chunk
    for (int i = 0; i < 15; i++)
    begin
        count_17bit[i] = 5'd0;
        for (int j = 0; j < 17; j++)
        begin
            count_17bit[i] = count_17bit[i] + in[i*17 + j];
        end
    end

    // Sum up the counts
    sum = 8'd0;
    for (int i = 0; i < 15; i++)
    begin
        sum = sum + count_17bit[i];
    end

    // Assign the final count to the output
    count = sum;
end

assign out = count;

endmodule