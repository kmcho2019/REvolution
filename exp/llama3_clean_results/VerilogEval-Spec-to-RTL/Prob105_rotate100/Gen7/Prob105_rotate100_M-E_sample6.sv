module TopModule(
    input               clk,
    input               load,
    input      [1:0]    ena,
    input      [99:0]   data,
    output reg [99:0]   q
);

reg [99:0] buffer; // Circular buffer to hold the data
reg [6:0] counter; // Counter to keep track of the starting point

always @(posedge clk) begin
    if (load) begin
        buffer <= data; // Load data into the buffer
        counter <= 0; // Reset the counter
    end else begin
        case (ena)
            2'b01: counter <= counter + 1; // Rotate right by one bit
            2'b10: counter <= counter - 1; // Rotate left by one bit
            default: ; // No rotation
        endcase
    end
end

// Generate the output q based on the current buffer and counter
genvar i;
generate
    for (i = 0; i < 100; i = i + 1) begin
        assign q[i] = buffer[(i + counter) % 100];
    end
endgenerate

endmodule