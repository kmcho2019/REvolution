module TopModule(
    input               clk,
    input               load,
    input      [1:0]    ena,
    input      [99:0]   data,
    output reg [99:0]   q
);

reg [99:0] q_reg;

always @(posedge clk) begin
    if (load) begin
        q_reg <= data;
    end else begin
        case (ena)
            2'b01: // Rotate right by one bit
                begin
                    reg temp;
                    temp = q_reg[0];
                    for (int i = 0; i < 99; i++) begin
                        q_reg[i] <= q_reg[i+1];
                    end
                    q_reg[99] <= temp;
                end
            2'b10: // Rotate left by one bit
                begin
                    reg temp;
                    temp = q_reg[99];
                    for (int i = 99; i > 0; i--) begin
                        q_reg[i] <= q_reg[i-1];
                    end
                    q_reg[0] <= temp;
                end
            default: // No rotation
                q_reg <= q_reg;
        endcase
    end
end

assign q = q_reg;

endmodule