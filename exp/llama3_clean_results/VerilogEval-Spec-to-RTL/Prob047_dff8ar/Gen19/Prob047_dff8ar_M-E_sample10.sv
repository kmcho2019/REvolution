// Parameterized D Flip-Flop module with active high asynchronous reset
module DFF(
    input           clk,        // Clock signal
    input           areset,     // Asynchronous reset signal
    input           d,          // Input data
    output          q           // Output data
);

    reg q_reg = 1'b0; // Initialize with reset value

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            q_reg <= 1'b0; // Reset condition
        end 
        else begin
            q_reg <= d; // Clock edge condition
        end
    end

    assign q = q_reg;

endmodule

// TopModule with 8 D flip-flops and active high asynchronous reset
module TopModule(
    input           clk,        // Clock signal
    input           areset,     // Asynchronous reset signal
    input   [7:0]   d,          // Input data
    output  [7:0]   q           // Output data
);

    genvar i;
    generate
        for (i = 0; i < 8; i++) begin
            DFF dff(.clk(clk), .areset(areset), .d(d[i]), .q(q[i]));
        end
    endgenerate

endmodule