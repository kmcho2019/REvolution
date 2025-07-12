module TopModule (
    input clk,
    input enable,
    input S,
    input A,
    input B,
    input C,
    output Z
);
    reg [7:0] shift_reg;
    wire [2:0] sel = {A, B, C};

    always @(posedge clk) begin
        if (enable) begin
            shift_reg <= {shift_reg[6:0], S};  // Standard shift operation
        end
    end

    // Direct output selection without explicit mux
    assign Z = shift_reg[sel];
endmodule