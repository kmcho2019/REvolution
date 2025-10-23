module TopModule(
    input clk,
    input load,
    input ena,
    input [1:0] amount,
    input [63:0] data,
    output [63:0] q
);

reg [7:0] byte_reg [7:0];
reg [7:0] byte_next [7:0];

always @(posedge clk) begin
    if (load) begin
        for (int i = 0; i < 8; i++) begin
            byte_reg[i] <= data[(i * 8) +: 8];
        end
    end else if (ena) begin
        case (amount)
            2'b00: begin
                for (int i = 0; i < 7; i++) begin
                    byte_next[i] <= byte_reg[i + 1];
                end
                byte_next[7] <= {7'b0, byte_reg[7][7]};
            end
            2'b01: begin
                for (int i = 0; i < 7; i++) begin
                    byte_next[i] <= (i < 7) ? byte_reg[i + 1] : 8'd0;
                end
                byte_next[7] <= 8'd0;
            end
            2'b10: begin
                for (int i = 1; i < 8; i++) begin
                    byte_next[i] <= byte_reg[i - 1];
                end
                byte_next[0] <= {byte_reg[0][0], 7'b0};
            end
            2'b11: begin
                for (int i = 1; i < 8; i++) begin
                    byte_next[i] <= (i > 1) ? byte_reg[i - 1] : {8{byte_reg[0][0]}};
                end
                byte_next[0] <= {8{byte_reg[0][0]}};
            end
            default: begin
                for (int i = 0; i < 8; i++) begin
                    byte_next[i] <= byte_reg[i];
                end
            end
        endcase
        for (int i = 0; i < 8; i++) begin
            byte_reg[i] <= byte_next[i];
        end
    end
end

assign q = {byte_reg[7], byte_reg[6], byte_reg[5], byte_reg[4], byte_reg[3], byte_reg[2], byte_reg[1], byte_reg[0]};

endmodule