module TopModule (
    input  clk,
    input  resetn,
    input  [2:0] r,
    output [2:0] g
);

reg [1:0] state;

always @(posedge clk) begin
    if (~resetn) begin
        state <= 2'b00;
    end else begin
        case (state)
            2'b00: // State A
                if (r[0] == 1'b1) begin
                    state <= 2'b01; // State B
                end else if (r[1] == 1'b1) begin
                    state <= 2'b10; // State C
                end else if (r[2] == 1'b1) begin
                    state <= 2'b10; // State C (grant access to device 2)
                end else begin
                    state <= 2'b00; // State A
                end
            2'b01: // State B
                if (r[0] == 1'b1) begin
                    state <= 2'b01; // State B
                end else begin
                    state <= 2'b00; // State A
                end
            2'b10: // State C
                if (r[1] == 1'b1 || r[2] == 1'b1) begin
                    state <= 2'b10; // State C
                end else begin
                    state <= 2'b00; // State A
                end
            default:
                state <= 2'b00; // State A
        endcase
    end
end

assign g[0] = (state == 2'b01); // g[0] is 1 in State B
assign g[1] = (state == 2'b10 && r[1] == 1'b1); // g[1] is 1 in State C if device 1 is requesting access
assign g[2] = (state == 2'b10 && r[2] == 1'b1 && r[1] == 1'b0); // g[2] is 1 in State C if device 2 is requesting access and device 1 is not

endmodule