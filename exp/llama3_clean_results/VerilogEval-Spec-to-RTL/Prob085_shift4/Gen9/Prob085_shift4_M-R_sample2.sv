module TopModule (
    input           clk,        // Clock signal
    input           areset,     // Asynchronous reset
    input           load,       // Synchronous load signal
    input           ena,        // Synchronous enable signal
    input   [3:0]   data,       // 4-bit data input
    output  [3:0]   q           // 4-bit output
);

reg [3:0] q_reg;  // Register to hold the shift register's value

// Combinational logic to determine the next state
wire [3:0] next_state;
assign next_state = (load) ? data : (ena) ? {1'b0, q_reg[3:1]} : q_reg;

// Sequential logic to update the state of the register
always @(posedge clk or posedge areset) begin
    if (areset) begin
        // Asynchronous reset to zero
        q_reg <= 4'b0;
    end else begin
        // Update the state of the register
        q_reg <= next_state;
    end
end

// Assign output
assign q = q_reg;

endmodule