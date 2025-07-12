module TopModule #(
    parameter WIDTH = 8
) (
    input clk,
    input enable,
    input S,
    input A,
    input B,
    input C,
    output Z
);
    reg [WIDTH-1:0] shift_reg;
    wire [2:0] sel = {A, B, C};

    always @(posedge clk) begin
        if (enable) begin
            shift_reg <= {shift_reg[WIDTH-2:0], S};
        end
    end

    // Direct indexing for optimal PPA
    assign Z = shift_reg[sel];
endmodule