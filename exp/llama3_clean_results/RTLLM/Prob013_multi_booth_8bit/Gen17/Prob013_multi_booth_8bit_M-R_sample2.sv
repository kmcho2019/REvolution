module multi_booth_8bit(
    input clk,
    input reset,
    input [7:0] a,
    input [7:0] b,
    output reg [15:0] p,
    output reg rdy
);

reg [15:0] multiplicand;
reg [15:0] multiplier;
reg [4:0] ctr;
reg [15:0] product;
reg [1:0] state;

// Combinational logic for state transitions and output
assign p = (state == 2) ? product : 0;
assign rdy = (state == 2);

// State 0: Initialization
always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= 0;
        multiplicand <= 0;
        multiplier <= 0;
        product <= 0;
        ctr <= 0;
    end else if (state == 0) begin
        multiplicand <= {{8{b[7]}}, b};
        multiplier <= {{8{a[7]}}, a};
        state <= 1;
    end
end

// State 1: Multiplication
always @(posedge clk) begin
    if (state == 1) begin
        if (ctr < 16) begin
            multiplicand <= multiplicand << 1;
            if (multiplier[ctr]) begin
                product <= product + multiplicand;
            end
            ctr <= ctr + 1;
        end else begin
            state <= 2;
        end
    end
end

// State 2: Output
always @(posedge clk) begin
    if (state == 2) begin
        state <= 0; // Reset state machine
    end
end

endmodule