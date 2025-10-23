module TopModule (
    input clk,
    input aresetn,
    input x,
    output reg z
);

    reg [1:0] shift_reg;  // Stores previous two bits
    wire z_comb;

    always @(posedge clk or negedge aresetn) begin
        if (!aresetn) begin
            shift_reg <= 2'b00;
            z <= 1'b0;
        end else begin
            shift_reg <= {shift_reg[0], x};
            z <= z_comb;  // Registered output
        end
    end

    // Combinational Mealy output
    assign z_comb = (shift_reg == 2'b10) && x;

endmodule