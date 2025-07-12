module TopModule(
    input clk,
    input load,
    input ena,
    input [1:0] amount,
    input [63:0] data,
    output [63:0] q
);

reg [63:0] q_reg;

// Define the next state of the shift register
wire [63:0] next_q;

assign next_q = (load) ? data :
                (ena) ? 
                    (amount == 2'b00) ? {q_reg[62:0], 1'b0} : 
                    (amount == 2'b01) ? {q_reg[55:0], 8'd0} : 
                    (amount == 2'b10) ? {q_reg[63], q_reg[63:1]} : 
                    (amount == 2'b11) ? {{8{q_reg[63]}}, q_reg[63:8]} : q_reg
                : q_reg;

// Update the state of the shift register
always @(posedge clk) begin
    case (1'b1)
        load: q_reg <= data;
        ena: 
            case (amount)
                2'b00: q_reg <= {q_reg[62:0], 1'b0}; // shift left by 1 bit
                2'b01: q_reg <= {q_reg[55:0], 8'd0}; // shift left by 8 bits
                2'b10: q_reg <= {q_reg[63], q_reg[63:1]}; // shift right by 1 bit (arithmetic)
                2'b11: q_reg <= {{8{q_reg[63]}}, q_reg[63:8]}; // shift right by 8 bits (arithmetic)
                default: q_reg <= q_reg;
            endcase
        default: q_reg <= q_reg;
    endcase
end

// Assign the output
assign q = q_reg;

endmodule