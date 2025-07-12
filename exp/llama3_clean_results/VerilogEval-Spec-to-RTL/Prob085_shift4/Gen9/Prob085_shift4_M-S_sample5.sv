module TopModule (
    input           clk,        // Clock signal
    input           areset,     // Asynchronous reset
    input           load,       // Synchronous load signal
    input           ena,        // Synchronous enable signal
    input   [3:0]   data,       // 4-bit data input
    output  [3:0]   q           // 4-bit output
);

reg [3:0] q_reg;  // Register to hold the shift register's value

always @(posedge clk or posedge areset) begin
    if (areset) begin
        q_reg <= 4'b0;
    end else begin
        if (load) begin
            q_reg <= data;
        end else if (ena) begin
            q_reg <= {1'b0, q_reg[3:1]};
        end
    end
end

assign q = q_reg;

endmodule