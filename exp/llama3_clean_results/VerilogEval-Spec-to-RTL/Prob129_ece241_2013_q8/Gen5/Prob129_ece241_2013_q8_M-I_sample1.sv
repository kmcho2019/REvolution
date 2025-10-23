module TopModule(
    input  clk,
    input  aresetn,
    input  x,
    output z
);

reg [2:0] state;
reg [2:0] nextState;

always @(negedge aresetn or posedge clk) begin
    if (!aresetn) begin
        state <= 3'b001;
    end else begin
        case (state)
            3'b001: state <= x? 3'b010 : 3'b001;
            3'b010: state <= x? 3'b010 : 3'b100;
            3'b100: state <= x? 3'b010 : 3'b001;
        endcase
    end
end

assign z = (state == 3'b100) && x;

endmodule