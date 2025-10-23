module multi_booth_8bit (
    input clk,
    input reset,
    input [7:0] a,
    input [7:0] b,
    output reg [15:0] p,
    output reg rdy
);

    // Internal registers
    reg [15:0] mcand_base;
    reg [7:0] mplier;
    reg [1:0] counter;
    reg prev_bit;
    
    // Booth encoding wires
    wire [2:0] booth_bits = {mplier[1:0], prev_bit};
    wire add_1x, add_2x, sub_1x, sub_2x;
    
    // Shift calculation
    wire [15:0] mcand_1x = mcand_base;
    wire [15:0] mcand_2x = {mcand_base[13:0], 2'b0};
    
    // Booth encoding decisions
    assign add_1x = (booth_bits == 3'b001) | (booth_bits == 3'b010);
    assign add_2x = (booth_bits == 3'b011);
    assign sub_1x = (booth_bits == 3'b101) | (booth_bits == 3'b110);
    assign sub_2x = (booth_bits == 3'b100);
    
    // Next product calculation
    wire [15:0] next_p = 
        (add_1x) ? p + mcand_1x :
        (add_2x) ? p + mcand_2x :
        (sub_1x) ? p - mcand_1x :
        (sub_2x) ? p - mcand_2x :
        p;
    
    // Next state logic
    wire done = (counter == 2'b11);
    wire [1:0] next_counter = done ? 2'b0 : counter + 1;
    wire next_rdy = done;
    wire next_prev_bit = mplier[1];
    
    always @(posedge clk) begin
        if (reset) begin
            mcand_base <= {{8{a[7]}}, a};
            mplier <= b;
            p <= 16'b0;
            counter <= 2'b0;
            prev_bit <= 1'b0;
            rdy <= 1'b0;
        end else begin
            p <= next_p;
            mplier <= mplier >> 2;
            counter <= next_counter;
            prev_bit <= next_prev_bit;
            rdy <= next_rdy;
        end
    end

endmodule