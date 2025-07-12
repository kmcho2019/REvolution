module TopModule(
    input  clk,
    input  resetn,
    input  [2:0] r,
    output [2:0] g
);

reg [2:0] state;
reg [2:0] next_state;

// Priority encoder to determine next state
always @(*) begin
    case (1'b1)
        r[0]: next_state = 3'b001;
        r[1]: next_state = 3'b010;
        r[2]: next_state = 3'b011;
        default: next_state = 3'b000;
    endcase
end

// State flip-flops
always @(posedge clk) begin
    if (~resetn) begin
        state <= 3'b000;
    end else begin
        case (state)
            3'b000: state <= next_state;
            3'b001: if (!r[0]) state <= 3'b000; else state <= 3'b001;
            3'b010: if (!r[1]) state <= 3'b000; else state <= 3'b010;
            3'b011: if (!r[2]) state <= 3'b000; else state <= 3'b011;
            default: state <= 3'b000;
        endcase
    end
end

// Output assignments
always @(*) begin
    case (state)
        3'b001: g = 3'b100;
        3'b010: g = 3'b010;
        3'b011: g = 3'b001;
        default: g = 3'b000;
    endcase
end

endmodule