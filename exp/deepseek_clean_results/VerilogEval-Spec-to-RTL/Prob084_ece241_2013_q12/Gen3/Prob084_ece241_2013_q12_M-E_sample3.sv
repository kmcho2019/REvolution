module TopModule (
    input clk,
    input enable,
    input S,
    input A,
    input B,
    input C,
    output Z
);

    // Memory array and write pointer
    reg [7:0] memory;
    reg [2:0] write_ptr;
    
    // Shift operation with circular buffer
    always @(posedge clk) begin
        if (enable) begin
            memory[write_ptr] <= S;
            write_ptr <= write_ptr + 1;  // Automatically wraps around
        end
    end

    // Read operation - direct indexing
    assign Z = memory[{A, B, C}];

endmodule