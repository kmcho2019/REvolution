module TopModule(
    input  clk,
    input  aresetn,
    input  x,
    output z
);

reg [1:0] shift_reg;

always_ff @(posedge clk or negedge aresetn) begin
    if (!aresetn) begin
        shift_reg <= 2'b00;
    end else begin
        shift_reg <= {shift_reg[0], x};
    end
end

// Using a wire for intermediate result to potentially improve synthesis
wire seq_match = (shift_reg == 2'b10);

assign z = seq_match && x;

endmodule