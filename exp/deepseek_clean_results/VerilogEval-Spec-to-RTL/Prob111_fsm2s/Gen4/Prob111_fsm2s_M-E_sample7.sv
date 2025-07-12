module TopModule (
    input  clk,
    input  reset,
    input  j,
    input  k,
    output reg out
);

    always @(posedge clk) begin
        if (reset) begin
            out <= 1'b0;  // Reset to OFF state (output = 0)
        end else begin
            case ({out, j, k})
                3'b000: out <= 1'b0;  // OFF, j=0: stay OFF
                3'b010: out <= 1'b1;  // OFF, j=1: go ON
                3'b100: out <= 1'b1;  // ON, k=0: stay ON
                3'b101: out <= 1'b0;  // ON, k=1: go OFF
                default: out <= out;   // Handle other cases (shouldn't occur)
            endcase
        end
    end

endmodule