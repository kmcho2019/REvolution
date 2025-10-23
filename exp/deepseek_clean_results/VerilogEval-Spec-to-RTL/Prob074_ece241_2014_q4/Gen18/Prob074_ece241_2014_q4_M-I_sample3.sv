module TopModule (
    input clk,
    input rst_n,    // Active-low synchronous reset
    input x,
    output z
);

    reg xor_ff;
    reg and_ff;
    reg or_ff;
    
    wire xor_in, and_in, or_in;

    // Combinational logic for gate inputs
    assign xor_in = x ^ xor_ff;      // XOR with own output
    assign and_in = x & ~and_ff;     // AND with complemented output
    assign or_in  = x | ~or_ff;      // OR with complemented output

    // Sequential logic with synchronous reset
    always @(posedge clk) begin
        if (!rst_n) begin
            xor_ff <= 1'b0;
            and_ff <= 1'b0;
            or_ff  <= 1'b0;
        end
        else begin
            xor_ff <= xor_in;
            and_ff <= and_in;
            or_ff  <= or_in;
        end
    end

    // Optimized output logic - single reduction NOR
    assign z = ~|{xor_ff, and_ff, or_ff};

endmodule