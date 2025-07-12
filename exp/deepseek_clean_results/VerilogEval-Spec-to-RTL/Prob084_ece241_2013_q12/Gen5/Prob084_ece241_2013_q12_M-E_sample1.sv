module TopModule (
    input clk,
    input enable,
    input S,
    input A,
    input B,
    input C,
    output Z
);
    reg [7:0] memory;
    reg [2:0] wptr;  // Write pointer
    wire [2:0] rptr = {A, B, C};  // Read pointer from ABC
    
    always @(posedge clk) begin
        if (enable) begin
            memory[wptr] <= S;  // Circular write
            wptr <= wptr + 1;   // Auto-wrap after 7
        end
    end
    
    assign Z = memory[rptr];  // Direct random access
endmodule