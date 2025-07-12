module TopModule(
    input  [254:0] in,
    output [7:0] out
);
    wire [7:0] count;

    // Count the number of '1's in the input vector
    always @(in) begin
        count = 8'd0;
        for (int i = 0; i < 255; i++) begin
            if (in[i])
                count = count + 1'd1;
        end
    end

    assign out = count;

endmodule