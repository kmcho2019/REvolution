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
reg [1:0] state;
reg [3:0] counter;
reg [15:0] product [3:0];

assign p = product[0] + product[1] + product[2] + product[3];

always @(posedge clk) begin
    if (reset) begin
        multiplicand <= 0;
        multiplier <= 0;
        state <= 0;
        counter <= 0;
        rdy <= 0;
        for (int i = 0; i < 4; i++) begin
            product[i] <= 0;
        end
    end else begin
        case (state)
            0: begin
                // Reset the registers and set the initial state
                multiplicand <= {{8{b[7]}}, b};
                multiplier <= {{8{a[7]}}, a};
                state <= 1;
            end
            1: begin
                // Perform the multiplication process
                for (int i = 0; i < 4; i++) begin
                    // Calculate the partial product for each unit
                    if (counter < 4) begin
                        product[i] <= product[i] + (multiplicand << (i * 4)) * multiplier[counter];
                    end
                    counter <= counter + 1;
                end
                if (counter == 16) begin
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