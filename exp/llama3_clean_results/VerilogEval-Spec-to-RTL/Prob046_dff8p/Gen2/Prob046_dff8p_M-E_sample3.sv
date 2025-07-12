// Custom D flip-flop with synchronous reset and shift register
module shift_reset_dff(
    input  clk,
    input  reset,
    input  load_reset,
    input  d,
    output reg q
);

    reg [7:0] reset_value;
    reg [7:0] shift_reg;

    // Load reset value into shift register
    always @(posedge load_reset) begin
        reset_value <= 8'b00110100;
    end

    // Shift reset value into shift register
    always @(posedge clk) begin
        if (reset) begin
            shift_reg <= {shift_reg[6:0], reset_value[7]};
        end else begin
            shift_reg <= shift_reg;
        end
    end

    // Load data into D flip-flop
    always @(negedge clk) begin
        if (reset) begin
            q <= shift_reg[0];
        end else begin
            q <= d;
        end
    end

endmodule

module TopModule(
    input  clk,
    input  reset,
    input  [7:0] d,
    output [7:0] q
);

    // 8-bit register with custom D flip-flops
    genvar i;
    generate
        for (i = 0; i < 8; i++) begin : dff_gen
            shift_reset_dff u_dff(
                .clk(clk),
                .reset(reset),
                .load_reset(reset),
                .d(d[i]),
                .q(q[i])
            );
        end
    endgenerate

endmodule