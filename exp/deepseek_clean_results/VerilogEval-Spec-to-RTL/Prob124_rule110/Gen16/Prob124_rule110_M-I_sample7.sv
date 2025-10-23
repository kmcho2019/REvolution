module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    // Pipeline registers
    reg [511:0] next_q_comb;
    reg [511:0] next_q_reg;

    // Extended neighbors with boundary conditions (0)
    wire [513:0] extended_q = {1'b0, q, 1'b0};

    // Combinational next state calculation with simplified logic
    always @(*) begin
        for (integer i = 0; i < 512; i = i + 1) begin
            wire left = extended_q[i+2];
            wire center = extended_q[i+1];
            wire right = extended_q[i];
            
            // Simplified Rule 110 logic
            next_q_comb[i] = (center | right) & ~(left & center & ~right);
        end
    end

    // Pipeline stage to improve timing
    always @(posedge clk) begin
        next_q_reg <= next_q_comb;
    end

    // State transition logic with clock gating
    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else if (next_q_reg != q) begin  // Only update if state will change
            q <= next_q_reg;
        end
    end

endmodule