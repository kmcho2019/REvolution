module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    // Pipeline registers
    reg [511:0] q_shift1, q_shift2;
    reg [511:0] xor_or_stage;
    reg [511:0] or_stage;

    // Circular shift registers for neighbor access
    always @(posedge clk) begin
        if (load) begin
            q <= data;
            q_shift1 <= data;
            q_shift2 <= data;
        end else begin
            // Shift register provides natural neighbors
            q_shift1 <= q;
            q_shift2 <= q_shift1;
            
            // Pipeline stage 1: Compute XOR and OR terms
            xor_or_stage <= q ^ q_shift2;  // center XOR right
            or_stage <= q | q_shift2;      // center OR right
            
            // Pipeline stage 2: Final computation
            q <= xor_or_stage | (~q_shift1 & or_stage);
        end
    end

endmodule