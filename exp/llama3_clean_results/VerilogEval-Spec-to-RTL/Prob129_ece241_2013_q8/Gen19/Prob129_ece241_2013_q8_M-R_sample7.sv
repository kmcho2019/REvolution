module TopModule(
    input  clk,
    input  aresetn,
    input  x,
    output z
);

reg [1:0] counter;

always @(negedge aresetn or posedge clk) begin
    if (!aresetn) begin
        counter <= 2'b00;
    end else begin
        case (counter)
            2'b00: counter <= x ? 2'b01 : 2'b00;
            2'b01: counter <= x ? 2'b11 : 2'b00;
            2'b11: counter <= x ? 2'b01 : 2'b00;
            default: counter <= 2'b00;
        endcase
    end
end

assign z = (counter == 2'b11);

endmodule