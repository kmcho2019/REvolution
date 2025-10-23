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
    wire [2:0] sel = {A, B, C};
    wire [7:0] one_hot = 1 << sel;
    
    always @(posedge clk) begin
        if (enable) begin
            // Barrel shift operation
            memory <= {memory[6:0], S};
        end
    end
    
    // Priority-encoded output selection
    assign Z = |(memory & one_hot);
endmodule