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

    // Shift register implementation
    always @(posedge clk) begin
        if (enable) begin
            shift_reg <= {shift_reg[6:0], S};
        end
    end

    // Direct 8:1 mux implementation
    assign Z = (sel == 3'b000) ? shift_reg[0] :
               (sel == 3'b001) ? shift_reg[1] :
               (sel == 3'b010) ? shift_reg[2] :
               (sel == 3'b011) ? shift_reg[3] :
               (sel == 3'b100) ? shift_reg[4] :
               (sel == 3'b101) ? shift_reg[5] :
               (sel == 3'b110) ? shift_reg[6] :
               shift_reg[7];
endmodule