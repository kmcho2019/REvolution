module LFSR (
    input wire clk,
    input wire rst,
    output wire [3:0] out
);

    reg [3:0] lfsr_reg;

    wire feedback = ~(lfsr_reg[3] ^ lfsr_reg[2]);

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            lfsr_reg <= 4'b0001;  // Non-zero seed to prevent lock-up
        end else begin
            lfsr_reg <= {lfsr_reg[2:0], feedback};
        end
    end

    assign out = lfsr_reg;

endmodule