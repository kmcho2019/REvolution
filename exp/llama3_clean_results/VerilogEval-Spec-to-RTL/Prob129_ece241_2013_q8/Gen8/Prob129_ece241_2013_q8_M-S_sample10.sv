module TopModule(
    input  clk,
    input  aresetn,
    input  x,
    output z
);

reg [1:0] state;

// Asynchronous reset
always @(negedge aresetn or posedge clk) begin
    if (!aresetn) begin
        state <= 2'b00;
    end else begin
        case (state)
            2'b00: state <= x? 2'b01 : 2'b00;
            2'b01: state <= x? 2'b11 : 2'b00;
            2'b11: state <= x? 2'b11 : 2'b01;
            default: state <= 2'b00;
        endcase
    end
end

// Output logic
assign z = (state == 2'b11);

endmodule