module TopModule(
    input clk,
    input load,
    input ena,
    input [1:0] amount,
    input [63:0] data,
    output [63:0] q
);

// Divide the 64-bit register into 8 segments of 8 bits each
reg [7:0] q_reg [7:0];

// Control logic to determine shift direction and amount
wire [2:0] shift_amount;
assign shift_amount = (amount == 2'b00) ? 3'b001 : // Shift left by 1 bit
                     (amount == 2'b01) ? 3'b100 : // Shift left by 8 bits
                     (amount == 2'b10) ? 3'b010 : // Shift right by 1 bit
                     3'b110; // Shift right by 8 bits

// Sequential logic for each segment
always @(posedge clk) begin
    if (load) begin
        for (int i = 0; i < 8; i++) begin
            q_reg[i] <= data[8*i +: 8];
        end
    end else if (ena) begin
        if (shift_amount[2]) begin // Shift right
            if (shift_amount[1]) begin // Shift right by 8 bits
                for (int i = 7; i > 0; i--) begin
                    q_reg[i] <= q_reg[i-1];
                end
                q_reg[0] <= {8{q_reg[7][7]}};
            end else begin // Shift right by 1 bit
                for (int i = 7; i > 0; i--) begin
                    q_reg[i] <= {q_reg[i][7], q_reg[i-1][7:1]};
                end
                q_reg[0] <= {q_reg[0][7], q_reg[0][7:1]};
            end
        end else begin // Shift left
            if (shift_amount[1]) begin // Shift left by 8 bits
                for (int i = 0; i < 7; i++) begin
                    q_reg[i] <= q_reg[i+1];
                end
                q_reg[7] <= 8'd0;
            end else begin // Shift left by 1 bit
                for (int i = 0; i < 7; i++) begin
                    q_reg[i] <= {q_reg[i][6:0], q_reg[i+1][7]};
                end
                q_reg[7] <= {q_reg[7][6:0], 1'b0};
            end
        end
    end
end

// Output logic
assign q = {q_reg[7], q_reg[6], q_reg[5], q_reg[4], q_reg[3], q_reg[2], q_reg[1], q_reg[0]};

endmodule