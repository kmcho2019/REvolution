module TopModule (
    input clk,
    input enable,
    input S,
    input A,
    input B,
    input C,
    output Z
);

    // 8-bit shift register implemented with continuous assignments
    wire [7:0] Q;
    reg [7:0] Q_reg;

    // Generate the shift register flip-flops
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : shift_reg
            if (i == 0) begin
                always @(posedge clk) begin
                    if (enable) Q_reg[i] <= S;
                end
            end else begin
                always @(posedge clk) begin
                    if (enable) Q_reg[i] <= Q_reg[i-1];
                end
            end
        end
    endgenerate

    assign Q = Q_reg;

    // 8:1 multiplexer using case statement
    wire [2:0] sel = {A, B, C};
    reg Z_reg;

    always @(*) begin
        case (sel)
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