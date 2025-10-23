module TopModule(
    input  clk,
    input  resetn,
    input  [2:0] r,
    output [2:0] g
);

reg [1:0] state;
reg [1:0] next_state;

// Idle state sub-module
always @(*) begin
    case (1'b1)
        r[0]: next_state = 2'b01; // Grant to device 0
        r[1] & ~r[0]: next_state = 2'b10; // Grant to device 1
        r[2] & ~r[0] & ~r[1]: next_state = 2'b11; // Grant to device 2
        default: next_state = 2'b00; // Stay in idle state
    endcase
end

// Grant state sub-module
always @(posedge clk) begin
    if (~resetn) state <= 2'b00;
    else begin
        case (state)
            2'b00: state <= next_state;
            2'b01: if (r[0]) state <= 2'b01; else state <= 2'b00;
            2'b10: if (r[1]) state <= 2'b10; else state <= 2'b00;
            2'b11: if (r[2]) state <= 2'b11; else state <= 2'b00;
            default: state <= 2'b00;
        endcase
    end
end

// Output assignments
assign g[0] = (state == 2'b01);
assign g[1] = (state == 2'b10);
assign g[2] = (state == 2'b11);

endmodule