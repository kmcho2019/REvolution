module TopModule (
    input  [15:0] a,
    input  [15:0] b,
    input  [15:0] c,
    input  [15:0] d,
    input  [15:0] e,
    input  [15:0] f,
    input  [15:0] g,
    input  [15:0] h,
    input  [15:0] i,
    input  [3:0]  sel,
    output [15:0] out
);

parameter DEFAULT_VAL = 16'hFFFF;

// Early detection of invalid selection
wire valid_sel = (sel < 9);

// Single always block for all bits
reg [15:0] selected_bits;

always @(*) begin
    if (!valid_sel) begin
        selected_bits = DEFAULT_VAL;
    end else begin
        // Flat case statement for balanced timing
        case (sel)
            4'd0: selected_bits = a;
            4'd1: selected_bits = b;
            4'd2: selected_bits = c;
            4'd3: selected_bits = d;
            4'd4: selected_bits = e;
            4'd5: selected_bits = f;
            4'd6: selected_bits = g;
            4'd7: selected_bits = h;
            4'd8: selected_bits = i;
            default: selected_bits = DEFAULT_VAL;
        endcase
    end
end

assign out = selected_bits;

endmodule