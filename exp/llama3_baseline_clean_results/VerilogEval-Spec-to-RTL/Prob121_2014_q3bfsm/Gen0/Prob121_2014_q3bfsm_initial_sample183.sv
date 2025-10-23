module TopModule(
    input clk,
    input reset,
    input x,
    output z
);

// Define states
parameter STATE_000 = 3'b000;
parameter STATE_001 = 3'b001;
parameter STATE_010 = 3'b010;
parameter STATE_011 = 3'b011;
parameter STATE_100 = 3'b100;
parameter STATE_011_X1 = 3'b001;
parameter STATE_100_X1 = 3'b010;
parameter STATE_100_X0 = 3'b011;

// Current state register
reg [2:0] y;

// Next state logic
reg [2:0] next_y;

// Output logic
always @(y) begin
    case (y)
        STATE_000, STATE_001, STATE_010: z = 0;
        STATE_011, STATE_100: z = 1;
        default: z = 0; // default output
    endcase
end

// Sequential logic
always @(posedge clk) begin
    if (reset) begin
        y <= STATE_000;
    end else begin
        case (y)
            STATE_000: y <= (x == 0)? STATE_000 : STATE_001;
            STATE_001: y <= (x == 0)? STATE_001 : STATE_100;
            STATE_010: y <= (x == 0)? STATE_010 : STATE_001;
            STATE_011: y <= (x == 0)? STATE_001 : STATE_010;
            STATE_100: y <= (x == 0)? STATE_011 : STATE_100;
            default: y <= STATE_000; // default next state
        endcase
    end
end

endmodule