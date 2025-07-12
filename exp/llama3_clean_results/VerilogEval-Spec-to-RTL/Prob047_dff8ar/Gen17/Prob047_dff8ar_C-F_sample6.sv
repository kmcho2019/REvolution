// Optimized D Flip-Flop module with active high asynchronous reset
module DFF_8bit(
    input           clk,        // Clock signal
    input           areset,     // Asynchronous reset signal
    input   [7:0]   d,          // Input data
    output  [7:0]   q           // Output data
);

    // Register to hold the output value
    reg [7:0] q_reg = 8'b0; // Initialize with reset value

    // Always block triggered on positive edge of clk or posedge of areset
    always @(posedge clk or posedge areset) begin
        // If areset is high, reset q_reg to 0
        if (areset) begin
            q_reg <= 8'b0; // Reset condition
        end 
        // Otherwise, update q_reg with the input d on the positive edge of clk
        else begin
            q_reg <= d; // Clock edge condition, simplified
        end
    end

    // Continuous assignment to output q
    assign q = q_reg;

endmodule

// TopModule remains the same for modularity and clarity
module TopModule(
    input           clk,        // Clock signal
    input           areset,     // Asynchronous reset signal
    input   [7:0]   d,          // Input data
    output  [7:0]   q           // Output data
);

    // Instantiate the DFF_8bit module
    DFF_8bit dff(.clk(clk),.areset(areset),.d(d),.q(q));

endmodule