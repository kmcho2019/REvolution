// TopModule: Refactored 4-bit shift register with asynchronous reset, synchronous load, and shift operations
module TopModule (
    input           clk,      // Clock signal
    input           areset,   // Asynchronous reset signal
    input           load,     // Load signal
    input           ena,      // Enable signal
    input   [3:0]    data,     // Input data
    output  [3:0]   q         // Output data
);

// 4-bit shift register
reg [3:0] q_reg;
reg [3:0] next_q_reg; // Next state of q_reg

// Combinational logic for next state of q_reg
always @(*) begin
    if (load) begin
        next_q_reg = data;
    end else if (ena) begin
        next_q_reg = {1'b0, q_reg[3:1]};
    end else begin
        next_q_reg = q_reg;
    end
end

// Sequential logic for updating q_reg
always @(posedge clk or posedge areset) begin
    if (areset) begin
        q_reg <= 4'b0;
    end else begin
        q_reg <= next_q_reg;
    end
end

// Assign output
assign q = q_reg;

endmodule