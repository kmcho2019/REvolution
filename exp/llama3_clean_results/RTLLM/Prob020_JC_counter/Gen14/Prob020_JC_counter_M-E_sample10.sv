// Module JC_counter: 64-bit Johnson counter using circular buffer approach
module JC_counter(
    input clk, // Clock signal
    input rst_n, // Active-low reset signal
    output reg [63:0] Q // 64-bit register representing the current count value
);

reg [5:0] ptr; // Pointer to current state in circular buffer
reg [63:0] buffer; // Circular buffer to store Johnson counter sequence

// Initialize buffer with initial state of Johnson counter sequence
initial begin
    buffer = 64'd1;
end

// Always block: synchronous operation
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        ptr <= 6'd0; // Reset pointer to initial state
        buffer <= 64'd1; // Reset buffer to initial state
    end else begin
        // Update pointer based on least significant bit
        if (buffer[0] == 1'b0) begin
            // Increment pointer (rotate right)
            ptr <= ptr + 6'd1;
        end else begin
            // Decrement pointer (rotate left)
            ptr <= ptr - 6'd1;
        end

        // Update buffer based on pointer
        buffer <= {buffer[62:0], buffer[63]};

        // Assign output Q based on buffer and pointer
        Q <= buffer;
    end
end

endmodule