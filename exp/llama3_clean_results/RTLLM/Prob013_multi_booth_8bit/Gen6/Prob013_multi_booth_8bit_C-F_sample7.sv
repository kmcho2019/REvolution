module multi_booth_8bit(
    input clk,
    input reset,
    input [7:0] a,
    input [7:0] b,
    output reg [15:0] p,
    output reg rdy
);

// Multiplicand Shift Register (MSR)
reg [15:0] multiplicand;
always @(posedge clk) begin
    if(reset) multiplicand <= { {8{b[7]}}, b };
    else multiplicand <= multiplicand << 1;
end

// Multiplier Register (MR)
reg [15:0] multiplier;
always @(posedge clk) begin
    if(reset) multiplier <= { {8{a[7]}}, a };
end

// Product Accumulator (PA)
reg [15:0] product;
always @(posedge clk) begin
    if(reset) product <= 0;
    else if(multiplier[0] == 1) product <= product + multiplicand;
end

// Control Unit (CU) with FSM
reg [4:0] ctr;
reg [1:0] state;
always @(posedge clk) begin
    if(reset) begin
        ctr <= 0;
        state <= 0;
        rdy <= 0;
    end else begin
        case(state)
            0: begin // initialization
                if(ctr < 16) begin
                    state <= 1;
                end else begin
                    state <= 2;
                end
            end
            1: begin // multiplication
                if(multiplier[ctr]) begin
                    product <= product + multiplicand;
                end
                multiplicand <= multiplicand << 1;
                ctr <= ctr + 1;
                if(ctr < 16) begin
                    state <= 1;
                end else begin
                    state <= 2;
                end
            end
            2: begin // done
                p <= product;
                rdy <= 1;
            end
        endcase
    end
end

endmodule