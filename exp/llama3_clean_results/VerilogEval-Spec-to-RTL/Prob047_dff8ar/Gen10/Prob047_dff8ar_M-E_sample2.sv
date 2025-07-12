// Novel Shift Register Implementation of TopModule
module TopModule(
    input           clk,
    input           areset,
    input   [7:0]   d,
    output  [7:0]   q
);

    reg [7:0] shift_reg;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            shift_reg <= 8'b0;
        end else begin
            shift_reg <= {d[6:0], 1'b0}; // Shift 'd' into 'shift_reg'
        end
    end

    assign q = shift_reg;

endmodule