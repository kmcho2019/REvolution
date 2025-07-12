module TopModule(
    input clk,
    input reset,
    input slowena,
    output [3:0] q
);

reg [3:0] state;

always @(posedge clk) begin
    if (reset) begin
        state <= 4'b0000;
    end else if (slowena) begin
        case (state)
'b0000: state <= 4'b0001;
'b0001: state <= 4'b0010;
'b0010: state <= 4'b0011;
'b0011: state <= 4'b0100;
'b0100: state <= 4'b0101;
'b0101: state <= 4'b0110;
'b0110: state <= 4'b0111;
'b0111: state <= 4'b1000;
'b1000: state <= 4'b1001;
'b1001: state <= 4'b0000;
            default: state <= 4'b0000;
        endcase
    end
end

assign q = state;

endmodule