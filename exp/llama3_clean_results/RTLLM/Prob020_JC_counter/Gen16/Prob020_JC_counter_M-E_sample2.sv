// Module JC_counter: 64-bit Johnson counter using circular buffer
module JC_counter(
    input clk, // Clock signal
    input rst_n, // Active-low reset signal
    output reg [63:0] Q // 64-bit register representing the current count value
);

// Define the size of the circular buffer
localparam BUFFER_SIZE = 64;

// Initialize the circular buffer with the initial state of the Johnson counter
reg [63:0] buffer [BUFFER_SIZE-1:0];

// Counter to keep track of the current position in the circular buffer
reg [5:0] counter;

// Always block: synchronous operation
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        // Reset the counter and the circular buffer
        counter <= 6'd0;
        for (int i = 0; i < BUFFER_SIZE; i++) begin
            buffer[i] <= (i == 0)? 64'd1 : 64'd0;
        end
    end else begin
        // Increment the counter and rotate the circular buffer
        counter <= counter + 1;
        buffer[0] <= {~buffer[0][0], buffer[0][63:1]};
        for (int i = 1; i < BUFFER_SIZE; i++) begin
            buffer[i] <= buffer[i-1];
        end
    end
end

// Generate the output Q based on the current position in the circular buffer
always @(*) begin
    Q = buffer[counter];
end

endmodule