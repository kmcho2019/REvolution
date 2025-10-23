module TopModule(
    input clk,
    input reset,
    output [9:0] q
);

parameter NUM_STATES = 1000;
parameter OUTPUT_WIDTH = 10;

reg [OUTPUT_WIDTH-1:0] state;
reg [OUTPUT_WIDTH-1:0] next_state;

always @(posedge clk) begin
    if (reset) begin
        state <= 'd0;
    end else if (state == NUM_STATES - 1) begin
        state <= 'd0;
    end else begin
        state <= state + 1'd1;
    end
end

always @(*) begin
    case (state)
        'd0: next_state = 'd0;
        'd1: next_state = 'd1;
        'd2: next_state = 'd2;
        'd3: next_state = 'd3;
        'd4: next_state = 'd4;
        'd5: next_state = 'd5;
        'd6: next_state = 'd6;
        'd7: next_state = 'd7;
        'd8: next_state = 'd8;
        'd9: next_state = 'd9;
        'd10: next_state = 'd10;
        'd11: next_state = 'd11;
        'd12: next_state = 'd12;
        'd13: next_state = 'd13;
        'd14: next_state = 'd14;
        'd15: next_state = 'd15;
        'd16: next_state = 'd16;
        'd17: next_state = 'd17;
        'd18: next_state = 'd18;
        'd19: next_state = 'd19;
        'd20: next_state = 'd20;
        'd21: next_state = 'd21;
        'd22: next_state = 'd22;
        'd23: next_state = 'd23;
        'd24: next_state = 'd24;
        'd25: next_state = 'd25;
        'd26: next_state = 'd26;
        'd27: next_state = 'd27;
        'd28: next_state = 'd28;
        'd29: next_state = 'd29;
        'd30: next_state = 'd30;
        'd31: next_state = 'd31;
        'd32: next_state = 'd32;
        'd33: next_state = 'd33;
        'd34: next_state = 'd34;
        'd35: next_state = 'd35;
        'd36: next_state = 'd36;
        'd37: next_state = 'd37;
        'd38: next_state = 'd38;
        'd39: next_state = 'd39;
        'd40: next_state = 'd40;
        'd41: next_state = 'd41;
        'd42: next_state = 'd42;
        'd43: next_state = 'd43;
        'd44: next_state = 'd44;
        'd45: next_state = 'd45;
        'd46: next_state = 'd46;
        'd47: next_state = 'd47;
        'd48: next_state = 'd48;
        'd49: next_state = 'd49;
        'd50: next_state = 'd50;
        'd51: next_state = 'd51;
        'd52: next_state = 'd52;
        'd53: next_state = 'd53;
        'd54: next_state = 'd54;
        'd55: next_state = 'd55;
        'd56: next_state = 'd56;
        'd57: next_state = 'd57;
        'd58: next_state = 'd58;
        'd59: next_state = 'd59;
        'd60: next_state = 'd60;
        'd61: next_state = 'd61;
        'd62: next_state = 'd62;
        'd63: next_state = 'd63;
        'd64: next_state = 'd64;
        'd65: next_state = 'd65;
        'd66: next_state = 'd66;
        'd67: next_state = 'd67;
        'd68: next_state = 'd68;
        'd69: next_state = 'd69;
        'd70: next_state = 'd70;
        'd71: next_state = 'd71;
        'd72: next_state = 'd72;
        'd73: next_state = 'd73;
        'd74: next_state = 'd74;
        'd75: next_state = 'd75;
        'd76: next_state = 'd76;
        'd77: next_state = 'd77;
        'd78: next_state = 'd78;
        'd79: next_state = 'd79;
        'd80: next_state = 'd80;
        'd81: next_state = 'd81;
        'd82: next_state = 'd82;
        'd83: next_state = 'd83;
        'd84: next_state = 'd84;
        'd85: next_state = 'd85;
        'd86: next_state = 'd86;
        'd87: next_state = 'd87;
        'd88: next_state = 'd88;
        'd89: next_state = 'd89;
        'd90: next_state = 'd90;
        'd91: next_state = 'd91;
        'd92: next_state = 'd92;
        'd93: next_state = 'd93;
        'd94: next_state = 'd94;
        'd95: next_state = 'd95;
        'd96: next_state = 'd96;
        'd97: next_state = 'd97;
        'd98: next_state = 'd98;
        'd99: next_state = 'd99;
        default: next_state = state;
    endcase
end

assign q = next_state;

endmodule