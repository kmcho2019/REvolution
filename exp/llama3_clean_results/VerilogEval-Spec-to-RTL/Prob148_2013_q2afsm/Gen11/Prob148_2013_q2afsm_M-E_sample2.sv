module TopModule(
    input  clk,
    input  resetn,
    input  [2:0] r,
    output [2:0] g
);

reg [2:0] state;
reg [2:0] next_state;

// Priority decoder to determine next state
always @(*) begin
    case (1'b1)
        r[0]: next_state = 3'b010;
        r[1]: next_state = 3'b100;
        r[2]: next_state = 3'b001;
        default: next_state = 3'b001;
    endcase
end

// State flip-flops
always @(posedge clk) begin
    if (~resetn) state <= 3'b001;
    else begin
        case (state)
            3'b001: if (r[0]) state <= 3'b010; else if (r[1]) state <= 3'b100; else if (r[2]) state <= 3'b001; else state <= 3'b001;
            3'b010: if (!r[0]) state <= 3'b001; else state <= 3'b010;
            3'b100: if (!r[1]) state <= 3'b001; else state <= 3'b100;
            3'b000: state <= 3'b001;
            default: state <= 3'b001;
        endcase
    end
end

// Output assignments
assign g[0] = (state == 3'b010);
assign g[1] = (state == 3'b100);
assign g[2] = (state == 3'b001);

endmodule