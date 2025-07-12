// Simplified D Flip-Flop module with active high asynchronous reset
module TopModule(
    input           clk,
    input           areset,
    input   [7:0]   d,
    output  [7:0]   q
);

    reg [7:0] q_reg = 8'b0; // Initialize with reset value

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            q_reg <= 8'b0; // Reset condition
        end else begin
            q_reg <= d; // Assign d to q_reg on positive clock edge when areset is low
        end
    end

    assign q = q_reg;

endmodule