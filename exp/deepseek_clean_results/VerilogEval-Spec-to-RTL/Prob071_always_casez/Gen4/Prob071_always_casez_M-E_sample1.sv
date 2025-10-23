module TopModule (
    input [7:0] in,
    output reg [2:0] pos
);

wire [1:0] nibble_sel;
wire [3:0] selected_nibble;

// First level: Detect which nibble has the first '1'
assign nibble_sel[0] = |in[3:0];  // LSB nibble has a '1'
assign nibble_sel[1] = |in[7:4] & ~nibble_sel[0]; // MSB nibble has first '1' if LSB is all 0s

// Select the appropriate nibble
assign selected_nibble = nibble_sel[1] ? in[7:4] : 
                        nibble_sel[0] ? in[3:0] : 4'b0;

// Second level: Find first '1' within selected nibble
always @(*) begin
    if (~|in) begin
        pos = 3'd0;  // All zeros case
    end else begin
        case (1'b1)
            selected_nibble[0]: pos = {nibble_sel[1], 2'b00};
            selected_nibble[1]: pos = {nibble_sel[1], 2'b01};
            selected_nibble[2]: pos = {nibble_sel[1], 2'b10};
            selected_nibble[3]: pos = {nibble_sel[1], 2'b11};
            default: pos = 3'd0;
        endcase
    end
end

endmodule