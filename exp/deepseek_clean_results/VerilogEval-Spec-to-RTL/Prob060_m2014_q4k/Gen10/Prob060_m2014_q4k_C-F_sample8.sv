module TopModule (
    input clk,
    input resetn,
    input in,
    output out
);

    parameter WIDTH = 4;
    reg [WIDTH-1:0] shift_reg;
    
    assign out = shift_reg[WIDTH-1];
    
    always @(posedge clk) begin
        if (!resetn) begin
            shift_reg <= {WIDTH{1'b0}};
        end else begin
            shift_reg <= {shift_reg[WIDTH-2:0], in};
        end
    end

endmodule