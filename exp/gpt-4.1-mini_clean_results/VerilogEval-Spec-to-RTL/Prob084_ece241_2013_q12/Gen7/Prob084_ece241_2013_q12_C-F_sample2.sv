module TopModule (
    input        clk,
    input        enable,
    input        S,
    input        A,
    input        B,
    input        C,
    output       Z
);

    reg [7:0] Q;

    // Shift register with synchronous enable, shifting MSB first on posedge clk
    always @(posedge clk) begin
        if (enable)
            Q <= {Q[6:0], S};
    end

    // Multiplexer selecting Q bit based on ABC using explicit combinational case statement
    wire [2:0] sel = {A, B, C};
    reg mux_out;
    always @(*) begin
        case (sel)
            3'b000: mux_out = Q[0];
            3'b001: mux_out = Q[1];
            3'b010: mux_out = Q[2];
            3'b011: mux_out = Q[3];
            3'b100: mux_out = Q[4];
            3'b101: mux_out = Q[5];
            3'b110: mux_out = Q[6];
            3'b111: mux_out = Q[7];
            default: mux_out = 1'b0; // Safe default though unreachable
        endcase
    end

    assign Z = mux_out;

endmodule