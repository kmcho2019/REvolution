module TopModule(
    input [254:0] in, 
    output [7:0] out
);

    // Initialize the output
    reg [7:0] out_reg;

    // Initialize the internal wires
    wire [7:0] three_bit_counts [84:0];

    // Initialize the 3-bit counter
    integer i;
    always @(*) begin
        out_reg = 8'd0;
        for(i = 0; i < 85; i = i + 1) begin
            case({in[3*i + 2], in[3*i + 1], in[3*i]})
                3'b000: three_bit_counts[i] = 8'd0;
                3'b001, 3'b010, 3'b100: three_bit_counts[i] = 8'd1;
                3'b011, 3'b101, 3'b110: three_bit_counts[i] = 8'd2;
                3'b111: three_bit_counts[i] = 8'd3;
            endcase
            out_reg = out_reg + three_bit_counts[i];
        end
    end

    assign out = out_reg;

endmodule