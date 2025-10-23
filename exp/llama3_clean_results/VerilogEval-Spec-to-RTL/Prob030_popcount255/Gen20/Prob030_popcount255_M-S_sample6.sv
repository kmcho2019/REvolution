// Top-level module for population count
module TopModule(
    input [254:0] in,
    output [7:0] out
);

    // Divide the input into 32 segments of 8 bits
    wire [7:0] segment [31:0];

    // Assign the segments
    genvar i;
    for (i = 0; i < 32; i++) begin
        if (i == 31) begin
            assign segment[i] = {1'b0, in[254:248]};
        end else begin
            assign segment[i] = in[(i*8)+7:i*8];
        end
    end

    // Initialize sum
    reg [7:0] sum;

    // Initialize sum to 0
    initial sum = 0;

    // Calculate the population count
    always @(*) begin
        sum = 0;
        for (int i = 0; i < 32; i++) begin
            sum = sum + $countones(segment[i]);
        end
    end

    // Assign the output
    assign out = sum;

endmodule