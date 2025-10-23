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
reg enable;

// Clock gating to reduce power consumption
always @(posedge clk) begin
    if (reset) begin
        enable <= 0;
        state <= 2'b00;
    end else if (state == 2'b00) begin
        enable <= 1;
    end else if (state == 2'b11) begin
        enable <= 0;
    end
end

// Pipelining the design to reduce critical path
always @(posedge clk) begin
    if (reset) begin
        multiplicand <= 0;
        multiplier <= 0;
        product <= 0;
        ctr <= 0;
        rdy <= 0;
    end else if (enable) begin
        case (state)
            2'b00: begin
                // Reset the registers and set the initial state
                multiplicand <= {{8{b[7]}}, b};
                multiplier <= {{8{a[7]}}, a};
                state <= 2'b01;
            end
            2'b01: begin
                // Perform the multiplication process
                if (ctr < 16) begin
                    // Left shift the multiplicand
                    multiplicand <= multiplicand << 1;
                    // Check the current bit of the multiplier
                    if (multiplier[ctr] == 1) begin
                        // Accumulate the product
                        product <= product + multiplicand;
                    end
                    // Increment the counter
                    ctr <= ctr + 1;
                    state <= 2'b10;
                end else begin
                    // Set the final state
                    state <= 2'b11;
                end
            end
            2'b10: begin
                // Perform the multiplication process
                if (ctr < 16) begin
                    // Left shift the multiplicand
                    multiplicand <= multiplicand << 1;
                    // Check the current bit of the multiplier
                    if (multiplier[ctr] == 1) begin
                        // Accumulate the product
                        product <= product + multiplicand;
                    end
                    // Increment the counter
                    ctr <= ctr + 1;
                    state <= 2'b01;
                end else begin
                    // Set the final state
                    state <= 2'b11;
                end
            end
            2'b11: begin
                // Output the product and set the ready signal
                p <= product;
                rdy <= 1;
                state <= 2'b00;
            end
            default: begin
                state <= 2'b00;
            end
        endcase
    end
end

endmodule