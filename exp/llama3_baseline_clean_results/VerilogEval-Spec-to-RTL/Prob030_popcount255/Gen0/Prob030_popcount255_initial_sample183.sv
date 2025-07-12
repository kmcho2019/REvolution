module TopModule(
    input  [254:0] in,
    output [7:0] out
);

// Initialize variables to store counts at each stage
reg [7:0] out_count;

// Calculate the population count
integer i;
always @(in) begin
    out_count = 8'd0;
    for (i = 0; i < 255; i = i + 1) begin
        if (in[i] == 1'b1) begin
            out_count = out_count + 8'd1;
        end
    end
end

// Assign the calculated count to the output
assign out = out_count;

endmodule