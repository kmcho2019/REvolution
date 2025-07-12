module TopModule(
    input  clk,
    input  resetn,
    input  [2:0] r,
    output [2:0] g
);

reg [1:0] state;
reg [1:0] priority;

always @(posedge clk) begin
    if (~resetn) state <= 2'b00;
    else begin
        case (state)
            2'b00: begin
                if (r[0]) state <= 2'b00;
                else if (r[1]) state <= 2'b01;
                else if (r[2]) state <= 2'b10;
                else state <= 2'b00;
            end
            2'b01: state <= r[1] ? 2'b01 : 2'b00;
            2'b10: state <= r[2] ? 2'b10 : 2'b00;
            default: state <= 2'b00;
        endcase
    end
end

always @(*) begin
    if (r[0]) priority = 2'b00;
    else if (r[1]) priority = 2'b01;
    else if (r[2]) priority = 2'b10;
    else priority = 2'b11; // default value
end

always @(*) begin
    case (state)
        2'b00: g[0] = r[0], g[1] = 1'b0, g[2] = 1'b0;
        2'b01: g[0] = 1'b0, g[1] = r[1], g[2] = 1'b0;
        2'b10: g[0] = 1'b0, g[1] = 1'b0, g[2] = r[2];
        default: g[0] = 1'b0, g[1] = 1'b0, g[2] = 1'b0;
    endcase
end

endmodule