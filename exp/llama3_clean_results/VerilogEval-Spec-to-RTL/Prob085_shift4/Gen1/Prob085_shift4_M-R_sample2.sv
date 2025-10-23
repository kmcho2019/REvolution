module TopModule(
    input clk,
    input areset,
    input load,
    input ena,
    input [3:0] data,
    output [3:0] q
);

reg [3:0] q_reg;

// Asynchronous reset
always @(posedge areset) begin
    q_reg <= 4'b0;
end

// Clocked operations
always @(posedge clk) begin
    if (load) begin
        // Load data when load is high
        q_reg <= data;
    end else if (ena) begin
        // Shift right when ena is high
        q_reg <= {1'b0, q_reg[3:1]};
    end
end

assign q = q_reg;

endmodule