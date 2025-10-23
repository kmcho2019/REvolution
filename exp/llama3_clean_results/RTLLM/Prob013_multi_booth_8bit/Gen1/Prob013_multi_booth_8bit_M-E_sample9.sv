module multi_booth_8bit_pipelined(
    input clk,
    input reset,
    input [7:0] a,
    input [7:0] b,
    output reg [15:0] p,
    output reg rdy
);

// Pipeline stage registers
reg [15:0] multiplicand;
reg [15:0] multiplier;
reg [15:0] partial_product;
reg [15:0] product;
reg [4:0] ctr;

// Control signals
reg start;
reg busy;

// Initial stage: Reset and initialization
always @(posedge clk or posedge reset) begin
    if (reset) begin
        multiplicand <= { {8{b[7]}}, b };
        multiplier <= { {8{a[7]}}, a };
        partial_product <= 0;
        product <= 0;
        ctr <= 0;
        start <= 0;
        busy <= 0;
        rdy <= 0;
    end else if (start) begin
        // Pipeline stage 1: Multiplicand shifting and partial product generation
        if (ctr < 16) begin
            multiplicand <= multiplicand << 1;
            if (multiplier[ctr]) begin
                partial_product <= multiplicand;
            end else begin
                partial_product <= 0;
            end
            // Pipeline stage 2: Accumulation
            product <= product + partial_product;
            ctr <= ctr + 1;
            busy <= 1;
        end else begin
            rdy <= 1;
            busy <= 0;
        end
    end
end

// Control logic
always @(posedge clk) begin
    if (!busy) begin
        start <= 1;
    end else if (ctr >= 16) begin
        start <= 0;
    end
end

// Output assignment
assign p = product;

endmodule