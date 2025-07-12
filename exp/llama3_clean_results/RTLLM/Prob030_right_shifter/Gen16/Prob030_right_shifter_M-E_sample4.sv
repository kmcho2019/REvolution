module right_shifter(
    input clk,  // Clock signal
    input d,    // Input signal to be right-shifted
    output reg [7:0] q  // Output signal representing the result of the right shift operation
);

// Define the buffer size
localparam BUFFER_SIZE = 8;

// Define the buffer and counter
reg [7:0] buffer;
reg [2:0] counter;

// Always block to handle the buffer update
always @(posedge clk) begin
    // Update the counter
    counter <= counter + 1;

    // Update the buffer
    case (counter)
        3'b000: buffer[7] <= d;
        3'b001: buffer[6] <= d;
        3'b010: buffer[5] <= d;
        3'b011: buffer[4] <= d;
        3'b100: buffer[3] <= d;
        3'b101: buffer[2] <= d;
        3'b110: buffer[1] <= d;
        3'b111: buffer[0] <= d;
    endcase

    // Assign the output q
    q <= buffer;
end

// Initialize the buffer and counter
initial begin
    buffer = 8'b0;
    counter = 3'b000;
end

endmodule