module multi_booth_8bit(
    input clk, 
    input reset, 
    input [7:0] a, 
    input [7:0] b, 
    output [15:0] p, 
    output rdy
);

reg [15:0] multiplier; // multiplier register
reg [15:0] multiplicand; // multiplicand register
reg [15:0] product; // product register
reg [4:0] ctr; // counter
reg rdy_reg; // ready signal register

assign p = product; // assign product to output
assign rdy = rdy_reg; // assign ready signal to output

always @(posedge clk or posedge reset) begin
    if (reset) begin
        // reset state
        multiplier <= {{8{a[7]}}, a}; // initialize multiplier register
        multiplicand <= {{8{b[7]}}, b}; // initialize multiplicand register
        product <= 16'd0; // reset product register
        ctr <= 5'd0; // reset counter
        rdy_reg <= 1'b0; // reset ready signal
    end else begin
        // multiply state
        if (ctr < 16) begin
            // shift multiplicand register
            multiplicand <= multiplicand << 1;
            // accumulate product register
            if (multiplier[ctr]) begin
                product <= product + multiplicand;
            end
            // increment counter
            ctr <= ctr + 1;
            rdy_reg <= 1'b0; // clear ready signal
        end else begin
            // set ready signal
            rdy_reg <= 1'b1;
        end
    end
end

endmodule