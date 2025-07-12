module TopModule (
    input clk,
    input resetn,
    input in,
    output out
);

    reg [3:0] shift_reg;

    // Output assignment
    assign out = shift_reg[3];

    // Single always block for all flip-flops
    always @(posedge clk) begin
        if (!resetn) begin
            shift_reg <= 4'b0;
        end else begin
            shift_reg <= {shift_reg[2:0], in};
        end
    end

endmodule