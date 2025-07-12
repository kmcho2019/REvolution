module TopModule (
    input clk,
    input areset,
    input load,
    input ena,
    input [3:0] data,
    output [3:0] q
);

reg [3:0] q_reg; // Internal register to store the shift register's state
assign q = q_reg; // Output assignment

always @(posedge clk or posedge areset) begin
    if (areset) begin
        q_reg <= 4'b0; // Asynchronous reset to zero
    end else if (load) begin
        q_reg <= data; // Load data into the shift register
    end else if (ena) begin
        q_reg <= {1'b0, q_reg[3:1]}; // Shift right, introducing a zero at the MSB
    end
end

endmodule