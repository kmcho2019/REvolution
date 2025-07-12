module TopModule (
    input clk,
    input enable,
    input S,
    input A,
    input B,
    input C,
    output Z
);

    // Circular buffer implementation
    reg [7:0] memory;
    reg [2:0] pointer;  // Points to current "head" position

    always @(posedge clk) begin
        if (enable) begin
            // Rotate the memory and insert new bit at pointer position
            memory <= {memory[6:0], S};
            pointer <= pointer + 1;  // Update pointer position
        end
    end

    // Calculate read address using modular arithmetic
    wire [2:0] read_addr = pointer + {A, B, C};
    
    // Output selection using simple array indexing
    assign Z = memory[read_addr];

endmodule