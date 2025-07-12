module up_down_counter (
    input clk,
    input reset,
    input up_down,
    output reg [15:0] count
);

// Digit definitions (4 digits of 4 bits each)
wire [3:0] digit0 = count[3:0];
wire [3:0] digit1 = count[7:4];
wire [3:0] digit2 = count[11:8];
wire [3:0] digit3 = count[15:12];

// Digit boundary conditions
wire digit0_max = up_down ? (digit0 == 4'd9) : (digit0 == 4'd0);
wire digit1_max = up_down ? (digit1 == 4'd9) : (digit1 == 4'd0);
wire digit2_max = up_down ? (digit2 == 4'd9) : (digit2 == 4'd0);

// Next digit values with carry propagation
wire [3:0] next_digit0 = up_down ? 
                         (digit0 == 4'd9 ? 4'd0 : digit0 + 1'b1) : 
                         (digit0 == 4'd0 ? 4'd9 : digit0 - 1'b1);

wire [3:0] next_digit1 = digit0_max ? 
                         (up_down ? 
                          (digit1 == 4'd9 ? 4'd0 : digit1 + 1'b1) : 
                          (digit1 == 4'd0 ? 4'd9 : digit1 - 1'b1)) : 
                         digit1;

wire [3:0] next_digit2 = (digit0_max & digit1_max) ? 
                         (up_down ? 
                          (digit2 == 4'd9 ? 4'd0 : digit2 + 1'b1) : 
                          (digit2 == 4'd0 ? 4'd9 : digit2 - 1'b1)) : 
                         digit2;

wire [3:0] next_digit3 = (digit0_max & digit1_max & digit2_max) ? 
                         (up_down ? 
                          (digit3 == 4'd9 ? 4'd0 : digit3 + 1'b1) : 
                          (digit3 == 4'd0 ? 4'd9 : digit3 - 1'b1)) : 
                         digit3;

// Combined next value
wire [15:0] next_count = {next_digit3, next_digit2, next_digit1, next_digit0};

always @(posedge clk) begin
    if (reset) begin
        count <= 16'h0000;
    end else begin
        // Only update if value will change (power optimization)
        if (next_count != count) begin
            count <= next_count;
        end
    end
end

endmodule