// Novel Memory-Based D Flip-Flop module with active high asynchronous reset
module MemoryDFF(
    input           clk,
    input           areset,
    input   [7:0]   d,
    output  [7:0]   q
);

    // Declare a reg to act as a small memory array
    reg [7:0] memory [0:0]; // Single location, 8-bit wide

    // Initialize the memory with reset value
    initial begin
        memory[0] = 8'b0;
    end

    // Always block for writing to memory on clk edge or resetting on areset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            // Reset the memory location
            memory[0] <= 8'b0;
        end else begin
            // Write input d to the memory location
            memory[0] <= d;
        end
    end

    // Continuous assignment to output q from memory
    assign q = memory[0];

endmodule

// TopModule using the novel Memory-Based D Flip-Flop
module TopModule(
    input           clk,
    input           areset,
    input   [7:0]   d,
    output  [7:0]   q
);

    // Instantiate the MemoryDFF module
    MemoryDFF mdff(.clk(clk), .areset(areset), .d(d), .q(q));

endmodule