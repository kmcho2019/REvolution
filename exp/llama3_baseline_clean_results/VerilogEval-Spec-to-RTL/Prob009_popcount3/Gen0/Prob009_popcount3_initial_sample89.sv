module TopModule(
    input  [2:0] in,  // input vector
    output [1:0] out  // output count
);

reg [1:0] count; // internal count variable

always @(in) begin
    count = 3'b0; // reset count to 0
    for (int i = 0; i < 3; i++) begin
        if (in[i] == 1'b1) begin // check if current bit is '1'
            count = count + 1'b1; // increment count
        end
    end
    out = count; // assign count to output
end

endmodule