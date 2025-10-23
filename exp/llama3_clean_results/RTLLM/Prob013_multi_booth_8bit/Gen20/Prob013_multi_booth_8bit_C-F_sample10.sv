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
reg [2:0] state;
reg enable;

// Clock gating to reduce power consumption
always @(posedge clk) begin
    if (reset) begin
        enable <= 0;
    end else if (state == 3'b000) begin
        enable <= 1;
    end else if (state == 3'b110) begin
        enable <= 0;
    end
end

// FSM to control the multiplication process
always @(posedge clk) begin
    if (reset) begin
        multiplicand <= {{8{b[7]}}, b};
        multiplier <= {{8{a[7]}}, a};
        ctr <= 0;
        product <= 0;
        rdy <= 0;
        state <= 3'b000;
    end else if (enable) begin
        case (state)
            3'b000: begin
                // Reset the registers and set the initial state
                multiplicand <= {{8{b[7]}}, b};
                multiplier <= {{8{a[7]}}, a};
                state <= 3'b001;
            end
            3'b001: begin
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
                    state <= 3'b010;
                end else begin
                    // Set the final state
                    state <= 3'b110;
                end
            end
            3'b010: begin
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
                    state <= 3'b001;
                end else begin
                    // Set the final state
                    state <= 3'b110;
                end
            end
            3'b110: begin
                // Output the product and set the ready signal
                p <= product;
                rdy <= 1;
                state <= 3'b000;
            end
            default: begin
                state <= 3'b000;
            end
        endcase
    end
end

endmodule