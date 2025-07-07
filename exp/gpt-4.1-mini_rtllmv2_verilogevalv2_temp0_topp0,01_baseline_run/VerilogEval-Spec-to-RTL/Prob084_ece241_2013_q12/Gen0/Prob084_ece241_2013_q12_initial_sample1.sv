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
            Q <= {Q[6:0], S};
        end
    end

    // 3-to-8 decoder for selecting one bit from Q
    wire [2:0] sel = {A,B,C};
    reg z_reg;

    always @(*) begin
        case(sel)
            3'b000: z_reg = Q[0];
            3'b001: z_reg = Q[1];
            3'b010: z_reg = Q[2];
            3'b011: z_reg = Q[3];
            3'b100: z_reg = Q[4];
            3'b101: z_reg = Q[5];
            3'b110: z_reg = Q[6];
            3'b111: z_reg = Q[7];
            default: z_reg = 1'b0;
        endcase
    end

    assign Z = z_reg;

endmodule