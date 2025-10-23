module BarrelShiftMemory (
    input clk,
    input enable,
    input S,
    input [2:0] sel,
    output reg Z,
    output reg [7:0] memory
);
    always @(posedge clk) begin
        if (enable) begin
            // Shift operation: rotate right and insert new bit at MSB
            memory <= {S, memory[7:1]};
        end
        // Always update output based on current selection
        Z <= memory[sel];
    end
endmodule

module TopModule (
    input clk,
    input enable,
    input S,
    input A,
    input B,
    input C,
    output Z
);
    wire [2:0] sel = {A, B, C};
    wire [7:0] memory_wire;  // Internal memory state (not used externally)
    
    BarrelShiftMemory bsm (
        .clk(clk),
        .enable(enable),
        .S(S),
        .sel(sel),
        .Z(Z),
        .memory(memory_wire)
    );
endmodule