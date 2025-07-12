module TopModule(
    input  clk,
    input  aresetn,
    input  x,
    output z
);

reg [2:0] state;

// Asynchronous reset
always @(negedge aresetn or posedge clk) begin
    if (!aresetn) begin
        state <= 3'b000;
    end else begin
        case (state)
            3'b000: state <= x ? 3'b100 : 3'b000;
            3'b100: state <= x ? 3'b101 : 3'b000;
            3'b101: state <= x ? 3'b101 : 3'b100;
            default: state <= 3'b000;
        endcase
    end
end

// Output logic
assign z = (state == 3'b101);

endmodule