module TopModule(c, d, mux_in);
    input c, d;
    output [3:0] mux_in;

    reg [3:0] mux_in_reg;

    always @(*)
    begin
        case({c, d})
            2'b00: mux_in_reg = 4'b0000;
            2'b01: mux_in_reg = 4'b1000;
            2'b10: mux_in_reg = 4'b1001;
            2'b11: mux_in_reg = 4'b1101;
        endcase
    end

    assign mux_in = mux_in_reg;
endmodule