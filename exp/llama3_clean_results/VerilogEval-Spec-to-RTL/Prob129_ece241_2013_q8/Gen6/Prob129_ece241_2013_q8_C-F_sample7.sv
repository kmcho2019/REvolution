module TopModule(
    input  clk,
    input  aresetn,
    input  x,
    output z
);

reg [1:0] shift_reg;
reg [2:0] state;

// Asynchronous reset
always @(negedge aresetn or posedge clk) begin
    if (!aresetn) begin
        shift_reg <= 2'b00;
        state <= 3'b001;
    end else begin
        shift_reg <= {shift_reg[0], x};
        case (state)
            3'b001: state <= x? 3'b010 : 3'b001;
            3'b010: state <= x? 3'b010 : 3'b100;
            3'b100: state <= x? 3'b010 : 3'b001;
        endcase
    end
end

// Output logic
assign z = (state == 3'b100) && x;

endmodule