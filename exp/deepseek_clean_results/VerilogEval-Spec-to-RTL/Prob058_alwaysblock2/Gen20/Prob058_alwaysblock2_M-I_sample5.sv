module TopModule (
    input  wire clk,
    input  wire a,
    input  wire b,
    output wire out_assign,
    output reg  out_always_comb,
    output reg  out_always_ff
);

    wire xor_result = a ^ b;
    
    // Continuous assignment
    assign out_assign = xor_result;
    
    // Combinational always block
    always @(*) begin
        out_always_comb = xor_result;
    end
    
    // Sequential always block with clock gating
    always @(posedge clk) begin
        if (a != b) begin  // Only update when inputs change
            out_always_ff <= xor_result;
        end
    end
    
    /* Optional asynchronous reset (commented out as not specified)
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            out_always_ff <= 1'b0;
        end else if (a != b) begin
            out_always_ff <= xor_result;
        end
    end
    */

endmodule