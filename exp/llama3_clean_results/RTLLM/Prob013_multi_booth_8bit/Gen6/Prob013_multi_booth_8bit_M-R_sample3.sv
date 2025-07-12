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
reg clock_enable;

// FSM to control the multiplication process
always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= 0;
        clock_enable <= 1'b0;
    end else begin
        case (state)
            0: begin
                state <= 1;
                clock_enable <= 1'b1;
            end
            1: begin
                if (ctr < 16) begin
                    state <= 1;
                end else begin
                    state <= 2;
                    clock_enable <= 1'b0;
                end
            end
            2: begin
                state <= 0;
            end
            default: begin
                state <= 0;
            end
        endcase
    end
end

// Update multiplicand, multiplier, and product registers
always @(posedge clk) begin
    if (clock_enable) begin
        if (state == 1) begin
            // Initialize multiplicand and multiplier registers
            if (ctr == 0) begin
                multiplicand <= {{8{b[7]}}, b};
                multiplier <= {{8{a[7]}}, a};
            end else begin
                // Left shift the multiplicand register
                multiplicand <= multiplicand << 1;
                // Add the multiplicand to the product if the current bit of the multiplier is 1
                if (multiplier[ctr] == 1) begin
                    product <= product + multiplicand;
                end
            end
            // Increment the counter
            ctr <= ctr + 1;
        end
    end
end

// Output assignments
always @(posedge clk) begin
    if (state == 2) begin
        p <= product;
        rdy <= 1'b1;
    end else begin
        rdy <= 1'b0;
    end
end

endmodule