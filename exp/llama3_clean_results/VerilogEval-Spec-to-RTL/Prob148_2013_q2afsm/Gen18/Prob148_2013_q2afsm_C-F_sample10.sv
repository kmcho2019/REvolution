module TopModule(
    input  clk,
    input  resetn,
    input  [2:0] r,
    output [2:0] g
);

reg [1:0] state;

// State table
always @(*) begin
    case (state)
        2'b00: begin
            if (r[0]) state = 2'b01;
            else if (r[1]) state = 2'b10;
            else if (r[2]) state = 2'b11;
            else state = 2'b00;
        end
        2'b01: if (!r[0]) state = 2'b00; else state = 2'b01;
        2'b10: if (!r[1]) state = 2'b00; else state = 2'b10;
        2'b11: if (!r[2]) state = 2'b00; else state = 2'b11;
    endcase
end

// State flip-flops
always @(posedge clk) begin
    if (~resetn) state <= 2'b00;
    else begin
        case (state)
            2'b00: begin
                if (r[0]) state <= 2'b01;
                else if (r[1]) state <= 2'b10;
                else if (r[2]) state <= 2'b11;
                else state <= 2'b00;
            end
            2'b01: if (!r[0]) state <= 2'b00; else state <= 2'b01;
            2'b10: if (!r[1]) state <= 2'b00; else state <= 2'b10;
            2'b11: if (!r[2]) state <= 2'b00; else state <= 2'b11;
        endcase
    end
end

// Output assignments
assign g[0] = (state == 2'b01);
assign g[1] = (state == 2'b10);
assign g[2] = (state == 2'b11);

endmodule