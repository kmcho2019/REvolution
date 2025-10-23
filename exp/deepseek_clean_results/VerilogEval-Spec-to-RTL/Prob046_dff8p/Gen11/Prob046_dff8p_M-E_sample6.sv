module TopModule (
    input clk,
    input reset,
    input [7:0] d,
    output [7:0] q
);

wire inverted_clk;
reg [7:0] q_reg;

// Clock inversion for negative edge triggering
assign inverted_clk = ~clk;

// Individual flip-flop instantiation using generate
genvar i;
generate
    for (i = 0; i < 8; i = i + 1) begin : dff_gen
        always @(posedge inverted_clk) begin
            if (reset) begin
                // Set reset value based on bit position (0x34 = 00110100)
                case (i)
                    2, 4, 5: q_reg[i] <= 1'b1;
                    default: q_reg[i] <= 1'b0;
                endcase
            end else begin
                q_reg[i] <= d[i];
            end
        end
    end
endgenerate

assign q = q_reg;

endmodule