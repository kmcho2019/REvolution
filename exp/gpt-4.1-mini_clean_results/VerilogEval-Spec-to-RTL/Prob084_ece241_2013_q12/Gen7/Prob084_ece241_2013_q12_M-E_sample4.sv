module TopModule (
    input        clk,
    input        enable,
    input        S,
    input        A,
    input        B,
    input        C,
    output       Z
);

    reg [7:0] shift_reg;

    // Shift register logic: On clock edge, if enable is high, shift in S to MSB
    always @(posedge clk) begin
        if (enable)
            shift_reg <= {S, shift_reg[7:1]};
    end

    wire [2:0] addr = {A, B, C};
    reg        mux_out;

    // 8-to-1 MUX to select the output bit from shift_reg based on addr
    always @(*) begin
        case (addr)
            3'b000: mux_out = shift_reg[0];
            3'b001: mux_out = shift_reg[1];
            3'b010: mux_out = shift_reg[2];
            3'b011: mux_out = shift_reg[3];
            3'b100: mux_out = shift_reg[4];
            3'b101: mux_out = shift_reg[5];
            3'b110: mux_out = shift_reg[6];
            3'b111: mux_out = shift_reg[7];
            default: mux_out = 1'b0;
        endcase
    end

    assign Z = mux_out;

endmodule