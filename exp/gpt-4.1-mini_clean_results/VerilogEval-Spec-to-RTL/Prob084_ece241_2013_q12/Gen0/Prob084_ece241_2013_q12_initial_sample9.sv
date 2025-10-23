module TopModule(
    input clk,
    input enable,
    input S,
    input A,
    input B,
    input C,
    output Z
);
    reg [7:0] Q;

    // Shift register with synchronous enable
    always @(posedge clk) begin
        if (enable) begin
            Q <= {Q[6:0], S}; // shift left, S shifted into Q[0]
        end
    end

    // 3-to-8 multiplexer to select output bit based on ABC
    // Concatenate ABC into a 3-bit selector
    wire [2:0] sel = {A, B, C};
    reg Z_reg;

    always @(*) begin
        case(sel)
            3'b000: Z_reg = Q[0];
            3'b001: Z_reg = Q[1];
            3'b010: Z_reg = Q[2];
            3'b011: Z_reg = Q[3];
            3'b100: Z_reg = Q[4];
            3'b101: Z_reg = Q[5];
            3'b110: Z_reg = Q[6];
            3'b111: Z_reg = Q[7];
            default: Z_reg = 1'b0;
        endcase
    end

    assign Z = Z_reg;

endmodule