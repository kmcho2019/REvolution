// TopModule: Top-level module with improved design
module TopModule (
    input           clk,      // Clock signal
    input           areset,   // Asynchronous reset signal
    input           load,     // Load signal
    input           ena,      // Enable signal
    input   [3:0]    data,     // Input data
    output  [3:0]    q         // Output data
);

    reg [3:0] q_reg;

    // Asynchronous reset, synchronous load and shift operations
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            q_reg <= 4'b0;
        end else if (load) begin
            // Load data directly into q_reg
            q_reg <= data;
        end else if (ena) begin
            // Shift q_reg right and fill the most significant bit with 0
            q_reg <= {1'b0, q_reg[3:1]};
        end else begin
            // Hold the current value of q_reg when neither load nor ena is asserted
            q_reg <= q_reg;
        end
    end

    // Assign output
    assign q = q_reg;

endmodule