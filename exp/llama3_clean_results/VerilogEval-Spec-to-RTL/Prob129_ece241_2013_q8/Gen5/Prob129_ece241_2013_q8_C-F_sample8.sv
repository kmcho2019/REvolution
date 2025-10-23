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
        state <= 1'b1;
    end else begin
        case (state)
            1'b1: state <= x ? 2 : 1;
            2: state <= x ? 4 : 1;
            4: state <= x ? 4 : 1;
            default: state <= 1;
        endcase
    end
end

// Output logic
assign z = (state == 4) && x;

endmodule