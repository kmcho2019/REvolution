module TopModule (
    input clk,
    input load,
    input [1:0] ena,
    input [99:0] data,
    output [99:0] q
);

reg [99:0] q_reg;
reg [6:0] rot_amount;

always @(posedge clk) begin
    if (load) begin
        q_reg <= data;
        rot_amount <= 0;
    end else begin
        case (ena)
            2'b01: rot_amount <= rot_amount + 1; // Rotate right by one bit
            2'b10: rot_amount <= rot_amount - 1; // Rotate left by one bit
            default: rot_amount <= rot_amount; // No rotation
        endcase

        // Barrel shifter implementation
        reg [99:0] temp;
        temp[99:75] <= (rot_amount[0]) ? {q_reg[74:75], q_reg[99:75]} : q_reg[99:75];
        temp[74:50] <= (rot_amount[1]) ? {q_reg[49:50], q_reg[74:50]} : q_reg[74:50];
        temp[49:25] <= (rot_amount[2]) ? {q_reg[24:25], q_reg[49:25]} : q_reg[49:25];
        temp[24:0] <= (rot_amount[3]) ? {q_reg[0:1], q_reg[24:1]} : q_reg[24:0];

        q_reg <= temp;
    end
end

assign q = q_reg;

endmodule