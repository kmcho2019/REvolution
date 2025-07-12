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

// Combinational logic for immediate updates
always @(*) begin
    if(reset) begin
        multiplicand = { {8{b[7]}}, b };
        multiplier = { {8{a[7]}}, a };
        ctr = 0;
        p = 0;
        rdy = 0;
    end
end

// Sequential logic for clocked operations
always @(posedge clk) begin
    if(!reset) begin
        if(ctr < 16) begin
            if(multiplier[ctr]) begin
                p <= p + multiplicand;
            end
            multiplicand <= multiplicand << 1;
            ctr <= ctr + 1;
        end else begin
            rdy <= 1;
        end
    end
end

endmodule