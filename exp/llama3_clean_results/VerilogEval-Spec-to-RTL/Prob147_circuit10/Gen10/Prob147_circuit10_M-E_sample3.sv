module TopModule(
    input clk,
    input a,
    input b,
    output q,
    output reg [1:0] state
);

always @(posedge clk) begin
    case(state)
        2'b00: // S0
            if (a == 1'b0 && b == 1'b1) begin
                state <= 2'b01; // S1
            end else begin
                state <= 2'b00; // S0
            end
        2'b01: // S1
            if (a == 1'b1 && b == 1'b1) begin
                state <= 2'b01; // S1
            end else if (a == 1'b1 && b == 1'b0) begin
                state <= 2'b01; // S1
            end else if (a == 1'b0 && b == 1'b0) begin
                state <= 2'b00; // S0
            end else begin
                state <= 2'b01; // S1
            end
        default: state <= 2'b00; // S0
    endcase
end

assign q = (state == 2'b01) || (state == 2'b00 && a == 1'b1 && b == 1'b0);

endmodule