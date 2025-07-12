module TopModule(
    input clk,
    input load,
    input ena,
    input [1:0] amount,
    input [63:0] data,
    output [63:0] q
);

reg [63:0] q_reg;

always @(posedge clk) begin
    if (load) begin
        q_reg <= data;
    end else if (ena) begin
        case (amount)
            2'b00: q_reg <= {q_reg[62:0], 1'b0}; // shift left by 1 bit
            2'b01: q_reg <= {q_reg[55:0], 8'd0}; // shift left by 8 bits
            2'b10: q_reg <= {q_reg[63], q_reg[63:1]}; // shift right by 1 bit (arithmetic)
            2'b11: q_reg <= {{8{q_reg[63]}}, q_reg[63:8]}; // shift right by 8 bits (arithmetic)
            default: q_reg <= q_reg;
        endcase
    end
end

assign q = q_reg;

// Barrel shifter implementation
// (commented out, as the above code is the main implementation)
// wire [63:0] shifted_data;
// reg [5:0] shift_amount;
// 
// always @(*) begin
//     case (amount)
//         2'b00: shift_amount = 6'd1;
//         2'b01: shift_amount = 6'd8;
//         2'b10: shift_amount = 6'd63;
//         2'b11: shift_amount = 6'd56;
//         default: shift_amount = 6'd0;
//     endcase
// end
// 
// barrel_shifter #(.WIDTH(64)) barrel_shifter_inst (
//     .data(q_reg),
//     .shift_amount(shift_amount),
//     .shifted_data(shifted_data)
// );
// 
// assign q = shifted_data;

endmodule

// (commented out, as the above code is the main implementation)
// module barrel_shifter #(
//     parameter WIDTH = 64
// ) (
//     input [WIDTH-1:0] data,
//     input [5:0] shift_amount,
//     output [WIDTH-1:0] shifted_data
// );
// 
// genvar i;
// generate
//     for (i = 0; i < WIDTH; i++) begin
//         assign shifted_data[i] = data[(i + shift_amount) % WIDTH];
//     end
// endgenerate
// 
// endmodule