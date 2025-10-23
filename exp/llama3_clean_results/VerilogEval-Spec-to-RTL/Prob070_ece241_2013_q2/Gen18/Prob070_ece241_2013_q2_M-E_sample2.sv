module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out_sop,
    output out_pos
);

// Define the 4-bit binary decoder
reg [3:0] decimal_value;
always @(*) begin
    decimal_value = {a, b, c, d};
end

// Define the SOP FSM
reg sop;
always @(*) begin
    case (decimal_value)
        4'd2: sop = 1'b1;
        4'd7: sop = 1'b1;
        4'd15: sop = 1'b1;
        default: sop = 1'b0;
    endcase
end

// Define the POS FSM
reg pos;
always @(*) begin
    case (decimal_value)
        4'd0: pos = 1'b0;
        4'd1: pos = 1'b0;
        4'd4: pos = 1'b0;
        4'd5: pos = 1'b0;
        4'd6: pos = 1'b0;
        4'd9: pos = 1'b0;
        4'd10: pos = 1'b0;
        4'd13: pos = 1'b0;
        4'd14: pos = 1'b0;
        default: pos = 1'b1;
    endcase
end

// Assign the FSM outputs to the module outputs
assign out_sop = sop;
assign out_pos = pos;

endmodule