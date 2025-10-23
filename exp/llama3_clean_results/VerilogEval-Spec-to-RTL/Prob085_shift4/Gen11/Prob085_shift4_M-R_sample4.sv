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
reg [3:0] q_next; // Next state of the shift register

// Combinational logic to determine the next state
always @(*) begin
    if (load) begin
        q_next = data;
    end else if (ena) begin
        q_next = {1'b0, q_reg[3:1]};
    end else begin
        q_next = q_reg;
    end
end

// Sequential logic to update the register
always @(posedge clk or posedge areset) begin
    if (areset) begin
        q_reg <= 4'b0;
    end else begin
        q_reg <= q_next;
    end
end

// Assign output
assign q = q_reg;

endmodule