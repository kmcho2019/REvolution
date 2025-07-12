module TopModule (
    input clk,
    input enable,
    input S,
    input A,
    input B,
    input C,
    output Z
);
    reg [7:0] mem;
    wire [2:0] sel = {A, B, C};
    
    // Circular shift register with parallel load capability
    always @(posedge clk) begin
        if (enable) begin
            mem <= {mem[6:0], S};  // Standard shift operation
        end
    end
    
    // Hierarchical 8:1 mux implementation
    wire [1:0] stage1_out;
    
    // First stage: 4:1 muxes (using C as selector)
    assign stage1_out[0] = sel[2] ? mem[sel[1:0]+4 : mem[sel[1:0]];
    assign stage1_out[1] = sel[2] ? mem[sel[1:0]+4+1 : mem[sel[1:0]+1];
    
    // Second stage: 2:1 mux (using C again for final selection)
    assign Z = sel[2] ? stage1_out[1] : stage1_out[0];
endmodule