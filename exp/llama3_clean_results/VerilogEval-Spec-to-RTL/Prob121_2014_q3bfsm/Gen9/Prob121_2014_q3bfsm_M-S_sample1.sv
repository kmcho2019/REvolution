module TopModule(
    input clk,
    input reset,
    input x,
    output reg z
);

reg [2:0] y; // current state

// Direct computation for next state logic
always @(*) begin
    case (y)
        3'b000: y = x? 3'b001 : 3'b000;
        3'b001: y = x? 3'b100 : 3'b001;
        3'b010: y = x? 3'b001 : 3'b010;
        3'b011: y = x? 3'b010 : 3'b001;
        3'b100: y = x? 3'b100 : 3'b011;
        default: y = 3'b000;
    endcase
end

// Direct computation for output logic
always @(*) begin
    case (y)
        3'b011, 3'b100: z = 1'b1;
        default: z = 1'b0;
    endcase
end

// Sequential logic
always @(posedge clk) begin
    if (reset) begin
        y <= 3'b000; // synchronous active high reset
    end else begin
        reg [2:0] next_y;
        case (y)
            3'b000: next_y = x? 3'b001 : 3'b000;
            3'b001: next_y = x? 3'b100 : 3'b001;
            3'b010: next_y = x? 3'b001 : 3'b010;
            3'b011: next_y = x? 3'b010 : 3'b001;
            3'b100: next_y = x? 3'b100 : 3'b011;
            default: next_y = 3'b000;
        endcase
        y <= next_y;
    end
end

endmodule