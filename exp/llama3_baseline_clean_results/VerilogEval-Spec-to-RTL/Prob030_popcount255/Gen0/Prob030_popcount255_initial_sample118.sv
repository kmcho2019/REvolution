module TopModule (
    input [254:0] in,
    output [7:0] out
);

reg [7:0] count;

// Initialize count to 0
initial count = 8'd0;

// Count the number of '1's in the input vector
always @(*) begin
    count = 8'd0;
    for (int i = 0; i < 255; i++) begin
        if (in[i]) begin
            count = count + 1;
        end
    end
end

// Assign the count to the output
assign out = count;

endmodule