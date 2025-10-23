module TopModule (
    input           clk,        // Clock signal
    input           areset,     // Asynchronous reset
    input           load,       // Synchronous load signal
    input           ena,        // Synchronous enable signal
    input   [3:0]   data,       // 4-bit data input
    output  [3:0]   q           // 4-bit output
);

// 4-bit shift register
reg [3:0] q_reg;  // Register to hold the shift register's value

// Next state logic
reg [3:0] next_state;

// Combinational logic for next state
always @(*) begin
    if (load) begin
        // Load data into shift register
        next_state = data;
    end else if (ena) begin
        // Shift right operation
        next_state = {1'b0, q_reg[3:1]};
    end else begin
        // Hold current state
        next_state = q_reg;
    end
end

// Sequential logic for state update
always @(posedge clk or posedge areset) begin
    if (areset) begin
        // Asynchronous reset to zero
        q_reg <= 4'b0;
    end else begin
        // Update state
        q_reg <= next_state;
    end
end

// Assign output
assign q = q_reg;

endmodule