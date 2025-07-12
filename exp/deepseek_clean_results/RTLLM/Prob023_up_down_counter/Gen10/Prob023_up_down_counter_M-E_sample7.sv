module up_down_counter (
    input clk,
    input reset,
    input up_down,
    output reg [15:0] count
);

// Internal nibble registers with individual carry signals
reg [3:0] nibble [0:3];
wire [3:0] carry;

// Nibble boundary conditions
wire [3:0] nibble_max = {4'hF, 4'hF, 4'hF, 4'hF};
wire [3:0] nibble_min = {4'h0, 4'h0, 4'h0, 4'h0};

// Carry generation logic
assign carry[0] = up_down ? (nibble[0] == 4'hF) : (nibble[0] == 4'h0);
assign carry[1] = up_down ? (nibble[1] == 4'hF) : (nibble[1] == 4'h0);
assign carry[2] = up_down ? (nibble[2] == 4'hF) : (nibble[2] == 4'h0);

always @(posedge clk) begin
    if (reset) begin
        // Selective reset - only reset nibbles that aren't already zero
        for (integer i = 0; i < 4; i = i+1) begin
            if (nibble[i] != 4'h0) nibble[i] <= 4'h0;
        end
    end else begin
        // Nibble 0 always counts
        nibble[0] <= up_down ? nibble[0] + 1'b1 : nibble[0] - 1'b1;
        
        // Conditional counting for upper nibbles
        for (integer i = 1; i < 4; i = i+1) begin
            if (carry[i-1]) begin
                nibble[i] <= up_down ? nibble[i] + 1'b1 : nibble[i] - 1'b1;
            end
        end
    end
end

// Combine nibbles to form final count
always @(*) begin
    count = {nibble[3], nibble[2], nibble[1], nibble[0]};
end

endmodule