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

// Initialize variables on reset
always @(posedge clk or posedge reset) begin
    if(reset) begin
        multiplicand <= { {8{b[7]}}, b };
        multiplier <= { {8{a[7]}}, a };
        p <= 16'd0; // Explicitly initialize p to 0
        ctr <= 5'd0; // Explicitly initialize ctr to 0
        rdy <= 1'b0; // Explicitly initialize rdy to 0
    end else begin
        // Sequential logic for the state machine
        if(ctr < 16) begin
            multiplicand <= multiplicand << 1; // Non-blocking assignment for sequential logic
            if(multiplier[ctr]) begin
                p <= p + multiplicand; // Accumulate product
            end
            ctr <= ctr + 1; // Increment counter
        end else if (ctr == 16) begin
            rdy <= 1'b1; // Set ready signal
        end
    end
end

endmodule