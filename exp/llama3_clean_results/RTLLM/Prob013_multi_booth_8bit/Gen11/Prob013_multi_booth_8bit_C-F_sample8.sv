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
reg [1:0] state;

// Pipelining the design
always @(posedge clk) begin
    if (reset) begin
        multiplicand <= 0;
        multiplier <= 0;
        ctr <= 0;
        p <= 0;
        rdy <= 0;
        state <= 0;
    end else begin
        case (state)
            0: begin
                // Reset the registers and set the initial state
                multiplicand <= { {8{b[7]}}, b };
                multiplier <= { {8{a[7]}}, a };
                state <= 1;
            end
            1: begin
                // Perform the multiplication process
                if (ctr < 16) begin
                    // Directly manipulate the multiplicand within the product accumulation logic
                    if (multiplier[ctr] == 1) begin
                        p <= p + multiplicand;
                    end
                    // Left shift the multiplicand
                    multiplicand <= multiplicand << 1;
                    // Increment the counter
                    ctr <= ctr + 1;
                end else begin
                    // Set the final state
                    state <= 2;
                end
            end
            2: begin
                // Output the product and set the ready signal
                rdy <= 1;
                state <= 0;
            end
            default: begin
                state <= 0;
            end
        endcase
    end
end

endmodule