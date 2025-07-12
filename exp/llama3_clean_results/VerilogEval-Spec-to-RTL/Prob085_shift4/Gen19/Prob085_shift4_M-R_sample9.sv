// TopModule: 4-bit shift register with asynchronous reset, synchronous load, and shift operations
module TopModule (
    input           clk,      // Clock signal
    input           areset,   // Asynchronous reset signal
    input           load,     // Load signal
    input           ena,      // Enable signal
    input   [3:0]    data,     // Input data
    output  [3:0]    q         // Output data
);

// 4-bit shift register
reg [3:0] q_reg;

// Asynchronous reset
always @(posedge areset) begin
    q_reg <= 4'b0;
end

// Next state logic
reg [3:0] next_state;
always @(*) begin
    if (load) begin
        next_state = data;
    end else if (ena) begin
        next_state = {1'b0, q_reg[3:1]};
    end else begin
        next_state = q_reg;
    end
end

// State update
always @(posedge clk) begin
    if (!areset) begin
        q_reg <= next_state;
    end
end

// Assign output
assign q = q_reg;

endmodule