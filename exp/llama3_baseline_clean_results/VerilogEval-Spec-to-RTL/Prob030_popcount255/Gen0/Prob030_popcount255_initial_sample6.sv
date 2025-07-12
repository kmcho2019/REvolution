module TopModule(
    input  [254:0] in,
    output [7:0] out
);

    // Initialize a register to hold the count
    reg [7:0] count;

    // Calculate the population count
    always @(*) begin
        count = 8'd0;
        for (int i = 0; i < 255; i++) begin
            count = count + {7'd0, in[i]};
        end
    end

    // Assign the count to the output
    assign out = count;

endmodule