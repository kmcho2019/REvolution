module TopModule (
    input [3:0] a,
    input [3:0] b,
    input [3:0] c,
    input [3:0] d,
    input [3:0] e,
    output [3:0] q
);

// Priority check: if c[3:2] are zero, we have a valid selection
wire valid_selection = ~|c[3:2];

// Output selection mux
reg [3:0] selected_output;
always @(*) begin
    if (valid_selection) begin
        case (c[1:0])
            2'b00: selected_output = b;
            2'b01: selected_output = e;
            2'b10: selected_output = a;
            2'b11: selected_output = d;
            default: selected_output = 4'b1111; // Should never happen
        endcase
    end
    else begin
        selected_output = 4'b1111; // 'f' output
    end
end

assign q = selected_output;

endmodule