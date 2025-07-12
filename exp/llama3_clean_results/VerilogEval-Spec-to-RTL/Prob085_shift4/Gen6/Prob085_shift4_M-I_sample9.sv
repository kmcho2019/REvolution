module TopModule(
    input clk,
    input areset,
    input load,
    input ena,
    input [3:0] data,
    output [3:0] q
);

reg [3:0] q_reg;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        q_reg <= 4'b0;
    end else if (load) begin
        // Load operation remains straightforward
        q_reg <= data;
    end else if (ena) begin
        // Using an alternative shift representation for potential synthesis optimization
        q_reg <= {1'b0, q_reg[3:1]};
    end else begin
        // Hold the current state if neither load nor ena is asserted
        q_reg <= q_reg;
    end
end

assign q = q_reg;

endmodule