module TopModule (
    input clk,
    input areset,
    input j,
    input k,
    output reg out
);

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            out <= 1'b0;
        end else begin
            case ({out, j, k})
                3'b000: out <= 1'b0;  // OFF, j=0: stay OFF
                3'b001: out <= 1'b0;  // OFF, j=0: stay OFF (k don't care)
                3'b010: out <= 1'b1;  // OFF, j=1: go ON
                3'b011: out <= 1'b1;  // OFF, j=1: go ON (k don't care)
                3'b100: out <= 1'b0;  // ON, k=1: go OFF
                3'b101: out <= 1'b0;  // ON, k=1: go OFF
                3'b110: out <= 1'b1;  // ON, k=0: stay ON
                3'b111: out <= 1'b1;  // ON, k=0: stay ON
            endcase
        end
    end

endmodule