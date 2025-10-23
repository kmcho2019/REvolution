module TopModule (
    input clk,
    input enable,
    input S,
    input A,
    input B,
    input C,
    output Z
);
    // 8-bit shift register with explicit flip-flops
    reg [7:0] Q;
    
    always @(posedge clk) begin
        if (enable) begin
            Q <= {Q[6:0], S};  // Shift left with new bit at LSB
        end
    end

    // Two-level hierarchical multiplexer
    wire mux_level1_0 = (B) ? (A ? Q[3] : Q[2]) : (A ? Q[1] : Q[0]);
    wire mux_level1_1 = (B) ? (A ? Q[7] : Q[6]) : (A ? Q[5] : Q[4]);
    
    // Final output selection
    assign Z = (C) ? mux_level1_1 : mux_level1_0;
endmodule