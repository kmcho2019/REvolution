module TopModule (
    input clk,
    input resetn,
    input in,
    output reg out
);

    reg [2:0] shift_reg;  // Reduced to 3 bits since we'll pipeline the last stage

    always @(posedge clk) begin
        if (!resetn) begin
            shift_reg <= 3'b0;
            out <= 1'b0;
        end
        else begin
            // Shift operation
            shift_reg <= {shift_reg[1:0], in};
            // Pipelined output stage
            out <= shift_reg[2];
        end
    end

endmodule