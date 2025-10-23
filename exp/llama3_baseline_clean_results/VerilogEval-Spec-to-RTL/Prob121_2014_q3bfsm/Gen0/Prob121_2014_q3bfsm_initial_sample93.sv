module TopModule(
    input clk,
    input reset,
    input x,
    output z
);

reg [2:0] y; // current state
reg [2:0] next_y; // next state

// output z is determined by the current state
always @(y)
begin
    case (y)
        3'b000: z = 1'b0;
        3'b001: z = 1'b0;
        3'b010: z = 1'b0;
        3'b011: z = 1'b1;
        3'b100: z = 1'b1;
        3'b101: z = 1'b0; // added this line to avoid latch
        3'b110: z = 1'b0; // added this line to avoid latch
        3'b111: z = 1'b0; // added this line to avoid latch
        default: z = 1'b0;
    endcase
end

// state transition logic
always @(y, x)
begin
    case (y)
        3'b000: 
            if (x == 1'b0) next_y = 3'b000;
            else next_y = 3'b001;
        3'b001: 
            if (x == 1'b0) next_y = 3'b001;
            else next_y = 3'b100;
        3'b010: 
            if (x == 1'b0) next_y = 3'b010;
            else next_y = 3'b001;
        3'b011: 
            if (x == 1'b0) next_y = 3'b001;
            else next_y = 3'b010;
        3'b100: 
            if (x == 1'b0) next_y = 3'b011;
            else next_y = 3'b100;
        default: next_y = 3'b000; // added this line to avoid latch
    endcase
end

// sequential logic
always @(posedge clk)
begin
    if (reset == 1'b1)
        y <= 3'b000;
    else
        y <= next_y;
end

endmodule