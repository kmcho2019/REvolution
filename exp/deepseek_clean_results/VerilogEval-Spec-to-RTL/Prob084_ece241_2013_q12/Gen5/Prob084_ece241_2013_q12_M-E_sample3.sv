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
    wire [2:0] addr = {A, B, C};
    
    always @(posedge clk) begin
        if (enable) begin
            // Barrel shift operation
            memory <= {memory[6:0], S};
        end
    end
    
    // Direct memory lookup
    assign Z = memory[addr];
endmodule