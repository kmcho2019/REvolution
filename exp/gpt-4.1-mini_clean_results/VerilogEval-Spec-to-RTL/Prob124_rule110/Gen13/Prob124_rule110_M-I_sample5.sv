module TopModule (
    input  wire         clk,
    input  wire         load,
    input  wire [511:0] data,
    output reg  [511:0] q
);

    // Pipeline registers
    reg [513:0] ext_q_reg;      // Extended q with zero padding (stage 1 register)
    reg [511:0] next_q_reg;     // Next state computed in stage 2

    // Extended vector creation with zero padding at both ends (stage 1 logic)
    always @(posedge clk) begin
        if (load) begin
            // Load input data and create extended vector in next cycle
            ext_q_reg <= {1'b0, data, 1'b0};
        end else begin
            // Use current q to create extended vector for next state computation
            ext_q_reg <= {1'b0, q, 1'b0};
        end
    end

    // Compute next state from registered extended vector (stage 2 combinational logic)
    // Rule 110: next = (~left & center) | (center ^ right)
    // Neighbors for cell i: left = ext_q_reg[i+2], center = ext_q_reg[i+1], right = ext_q_reg[i]
    integer i;
    always @(*) begin
        for (i = 0; i < 512; i = i + 1) begin
            // Extract neighbors
            wire left   = ext_q_reg[i+2];
            wire center = ext_q_reg[i+1];
            wire right  = ext_q_reg[i];
            // Apply Rule 110 formula
            next_q_reg[i] = (~left & center) | (center ^ right);
        end
    end

    // Update output register with load and next state logic (stage 2 register)
    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            q <= next_q_reg;
        end
    end

endmodule