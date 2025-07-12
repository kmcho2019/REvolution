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

    // Combined shift/parallel load operation
    always @(posedge clk) begin
        if (enable) begin
            // Shift operation
            memory <= {memory[6:0], S};
        end
    end

    // Direct output selection without separate mux
    assign Z = memory[{A, B, C}];
endmodule