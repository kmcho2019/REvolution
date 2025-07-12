module TopModule(
    input clk,
    input areset,
    input load,
    input ena,
    input [3:0] data,
    output [3:0] q
);

reg [3:0] q_reg; // internal register for shift register

// Asynchronous reset
always @(posedge clk or posedge areset) begin
    if (areset) begin
        q_reg <= 4'b0;
    end else begin
        if (load) begin
            // Load data into the shift register
            q_reg <= data;
        end else if (ena) begin
            // Shift the register to the right
            q_reg <= {1'b0, q_reg[3:1]};
        end
    end
end

// Continuous assignment for output
assign q = q_reg;

endmodule