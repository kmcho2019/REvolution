module TopModule(
    input  clk,
    input  aresetn,
    input  x,
    output z
);

reg [1:0] state;

always_ff @(posedge clk or negedge aresetn) begin
    if (!aresetn) begin
        state <= 2'b00;
    end else begin
        case (state)
            2'b00: state <= x ? 2'b01 : 2'b00;
            2'b01: state <= x ? 2'b10 : 2'b00;
            2'b10: state <= x ? 2'b10 : 2'b01;
            default: state <= 2'b00;
        endcase
    end
end

assign z = (state == 2'b10) && x;

endmodule