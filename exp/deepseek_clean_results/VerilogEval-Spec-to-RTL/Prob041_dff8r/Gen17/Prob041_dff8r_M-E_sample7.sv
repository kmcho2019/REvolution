module TopModule #(parameter WIDTH = 8) (
    input clk,
    input reset,
    input [WIDTH-1:0] d,
    output [WIDTH-1:0] q
);
    reg [WIDTH-1:0] shift_reg;
    
    always @(posedge clk) begin
        if (reset) begin
            shift_reg <= {WIDTH{1'b0}};  // Synchronous reset
        end else begin
            // Rotate data through the shift register
            shift_reg <= {shift_reg[WIDTH-2:0], shift_reg[WIDTH-1]};
            // Load new data on first cycle after reset
            if (shift_reg == {WIDTH{1'b0}}) begin
                shift_reg <= d;
            end
        end
    end
    
    assign q = shift_reg;
endmodule