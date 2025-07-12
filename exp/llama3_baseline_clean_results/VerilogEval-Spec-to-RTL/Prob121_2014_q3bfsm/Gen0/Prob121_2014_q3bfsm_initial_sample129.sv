module TopModule(
    input clk,
    input reset,
    input x,
    output z
);

// Define the states
parameter S000 = 3'b000;
parameter S001 = 3'b001;
parameter S010 = 3'b010;
parameter S011 = 3'b011;
parameter S100 = 3'b100;

// Define the state register
reg [2:0] y;
reg [2:0] next_y;

// Next state logic
always @(*) begin
    case (y)
        S000: next_y = x ? S001 : S000;
        S001: next_y = x ? S100 : S001;
        S010: next_y = x ? S001 : S010;
        S011: next_y = x ? S010 : S001;
        S100: next_y = x ? S100 : S011;
        default: next_y = S000; // Default state
    endcase
end

// Output logic
always @(*) begin
    case (y)
        S000, S001, S010: z = 0;
        S011, S100: z = 1;
        default: z = 0; // Default output
    endcase
end

// Sequential logic
always @(posedge clk) begin
    if (reset) begin
        y <= S000;
    end else begin
        y <= next_y;
    end
end

endmodule