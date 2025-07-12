module TopModule(
    input  clk,
    input  aresetn,
    input  x,
    output z
);

reg [1:0] state;

always @(negedge aresetn or posedge clk) begin
    if (!aresetn) begin
        state <= 0;
    end else begin
        case (state)
            0: state <= x ? 1 : 0;
            1: state <= x ? 1 : 2;
            2: state <= x ? 1 : 0;
        endcase
    end
end

assign z = (state == 2) && x;

endmodule