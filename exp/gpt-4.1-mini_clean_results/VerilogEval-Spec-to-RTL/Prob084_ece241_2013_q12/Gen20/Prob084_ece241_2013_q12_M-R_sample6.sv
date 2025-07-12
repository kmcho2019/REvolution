module TopModule (
    input       clk,
    input       enable,
    input       S,
    input       A,
    input       B,
    input       C,
    output      Z
);

    reg [7:0] shift_reg;
    wire [2:0] sel = {A, B, C};
    wire [7:0] decoded_sel;
    wire [7:0] mux_and;

    // Shift register: shift left by 1 with S shifted into Q[0] (LSB)
    always @(posedge clk) begin
        if (enable) begin
            shift_reg <= {shift_reg[6:0], S};
        end
    end

    // 3-to-8 decoder for selection bits (one-hot)
    assign decoded_sel = 8'b00000001 << sel;

    // AND each decoded select with corresponding shift_reg bit
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : mux_logic
            assign mux_and[i] = decoded_sel[i] & shift_reg[i];
        end
    endgenerate

    // OR all AND outputs to form multiplexed output
    assign Z = |mux_and;

endmodule