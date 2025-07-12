module TopModule (
    input clk,
    input enable,
    input S,
    input A,
    input B,
    input C,
    output Z
);

    reg [7:0] shift_reg;

    // On clock posedge, if enable, shift right, shifting S into MSB (bit 7)
    // This makes Q[0] = shift_reg[7], Q[7] = shift_reg[0], matching specification
    always @(posedge clk) begin
        if (enable) begin
            shift_reg <= {S, shift_reg[7:1]};
        end
    end

    // Create a vector Q indexed by [0] to [7] matching Q[0]=shift_reg[7]
    // We reverse bits so that Q[0]=shift_reg[7], Q[1]=shift_reg[6], ..., Q[7]=shift_reg[0]
    wire [7:0] Q = {shift_reg[7], shift_reg[6], shift_reg[5], shift_reg[4],
                    shift_reg[3], shift_reg[2], shift_reg[1], shift_reg[0]};

    // Use ABC as 3-bit address to select bit from Q, Z = Q[{A,B,C}]
    wire [2:0] addr = {A, B, C};
    assign Z = Q[addr];

endmodule