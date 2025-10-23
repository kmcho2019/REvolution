module TopModule (
    input [3:0] a,
    input [3:0] b,
    input [3:0] c,
    input [3:0] d,
    input [3:0] e,
    output [3:0] q
);

// Simplified invalid case detection
wire invalid_case = c[3];

// Optimized multiplexer using case statement
wire [3:0] selected_input;
always @(*) begin
    if (invalid_case) begin
        selected_input = 4'b1111;
    end else begin
        case (c[1:0])
            2'b00: selected_input = b;
            2'b01: selected_input = e;
            2'b10: selected_input = a;
            2'b11: selected_input = d;
            default: selected_input = 4'b1111;
        endcase
    end
end

assign q = selected_input;

endmodule