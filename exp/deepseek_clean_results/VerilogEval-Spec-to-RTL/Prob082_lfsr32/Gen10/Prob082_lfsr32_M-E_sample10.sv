module TopModule (
    input clk,
    input reset,
    output reg [31:0] q
);

reg [15:0] upper;
reg [15:0] lower;
wire feedback_bit;
wire [15:0] next_upper;
wire [15:0] next_lower;

// Feedback bit is always the LSB of lower register
assign feedback_bit = lower[0];

// Upper segment (bits 31:16)
assign next_upper = reset ? 16'h0 : 
                   {feedback_bit, 
                    upper[15:9], 
                    upper[8] ^ feedback_bit,  // Tap at position 22 (32-22=10, 16-10=6, 8-6=2?)
                    upper[7:0]};

// Lower segment (bits 15:0)
assign next_lower = reset ? 16'h1 : 
                   {lower[15:3], 
                    lower[2] ^ feedback_bit,  // Tap at position 2
                    lower[1] ^ feedback_bit,  // Tap at position 1
                    feedback_bit};

always @(posedge clk) begin
    if (reset) begin
        upper <= 16'h0;
        lower <= 16'h1;
    end else begin
        upper <= next_upper;
        lower <= next_lower;
    end
    q <= {upper, lower};
end

endmodule