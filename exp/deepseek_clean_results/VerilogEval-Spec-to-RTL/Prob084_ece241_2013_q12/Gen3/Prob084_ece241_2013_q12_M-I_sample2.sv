module TopModule (
    input clk,
    input enable,
    input S,
    input A,
    input B,
    input C,
    output Z
);

    // 8-bit circular buffer implementation
    reg [7:0] Q;
    reg [2:0] ptr;  // Pointer to current MSB position

    // Clock gating for power optimization
    wire gated_clk = clk & enable;

    always @(posedge gated_clk) begin
        Q[ptr] <= S;        // Store new bit at current pointer
        ptr <= ptr + 1;     // Circular increment pointer
    end

    // 8:1 multiplexer using direct array indexing
    // Adjusted for circular buffer access
    assign Z = Q[({A, B, C} + ptr) % 8];

endmodule