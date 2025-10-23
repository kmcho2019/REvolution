module TopModule(
    input  [3:0] a,
    input  [3:0] b,
    input  [3:0] c,
    input  [3:0] d,
    input  [3:0] e,
    output reg [3:0] q
);

wire [3:0] dec_out;
reg [3:0] mux_out;

always_comb begin
    // Decoder
    case (c[1:0])
        2'b00: dec_out = 4'b0001;
        2'b01: dec_out = 4'b0010;
        2'b10: dec_out = 4'b0100;
        2'b11: dec_out = 4'b1000;
    endcase

    // Multiplexers
    case (dec_out)
        4'b0001: mux_out = (c[3:2] == 2'b00)? b : 4'b1111;
        4'b0010: mux_out = (c[3:2] == 2'b00)? e : 4'b1111;
        4'b0100: mux_out = (c[3:2] == 2'b00)? a : 4'b1111;
        4'b1000: mux_out = (c[3:2] == 2'b00)? d : 4'b1111;
    endcase

    // Priority encoder
    if (c[3:2]!= 2'b00) begin
        q = 4'b1111;
    end else begin
        q = mux_out;
    end
end

endmodule