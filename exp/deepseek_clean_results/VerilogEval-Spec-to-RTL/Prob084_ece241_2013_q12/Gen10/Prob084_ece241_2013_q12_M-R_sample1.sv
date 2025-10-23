module TopModule (
    input clk,
    input enable,
    input S,
    input A,
    input B,
    input C,
    output Z
);
    wire [7:0] Q;
    reg [7:0] shift_reg;

    // Shift register implementation using continuous assignment
    always @(posedge clk) begin
        if (enable) begin
            shift_reg <= {shift_reg[6:0], S};
        end
    end

    assign Q = shift_reg;
    
    // 8:1 Mux implemented using direct indexing
    assign Z = Q[{A, B, C}];
endmodule