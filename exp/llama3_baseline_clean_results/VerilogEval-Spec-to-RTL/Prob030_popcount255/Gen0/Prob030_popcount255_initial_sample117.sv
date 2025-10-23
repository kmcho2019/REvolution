module TopModule(
    input  [254:0] in,  // 255-bit input vector
    output [7:0] out     // 8-bit output
);

reg [7:0] count;  // counter to store the population count

always @(in) begin
    count = 0;  // reset the counter
    for (int i = 0; i < 255; i++) begin
        if (in[i] == 1'b1) begin
            count = count + 1;  // increment the counter if the current bit is '1'
        end
    end
    out = count;  // assign the final count to the output
end

endmodule