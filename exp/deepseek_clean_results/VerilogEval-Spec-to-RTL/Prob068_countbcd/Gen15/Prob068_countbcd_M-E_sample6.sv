module BCD_Digit (
    input clk,
    input reset,
    input enable,
    output reg [3:0] value,
    output rollover
);

    assign rollover = (value == 4'd9) & enable;

    always @(posedge clk) begin
        if (reset) begin
            value <= 4'd0;
        end else if (enable) begin
            if (value == 4'd9) begin
                value <= 4'd0;
            end else begin
                value <= value + 4'd1;
            end
        end
    end

endmodule

module TopModule (
    input clk,
    input reset,
    output [2:0] ena,
    output [15:0] q
);

    wire [3:0] ones, tens, hundreds, thousands;
    wire rollover_ones, rollover_tens, rollover_hundreds;
    
    // Instantiate digit modules with cascaded enables
    BCD_Digit ones_digit (
        .clk(clk),
        .reset(reset),
        .enable(1'b1),  // Always enabled
        .value(ones),
        .rollover(rollover_ones)
    );
    
    BCD_Digit tens_digit (
        .clk(clk),
        .reset(reset),
        .enable(rollover_ones),
        .value(tens),
        .rollover(rollover_tens)
    );
    
    BCD_Digit hundreds_digit (
        .clk(clk),
        .reset(reset),
        .enable(rollover_tens),
        .value(hundreds),
        .rollover(rollover_hundreds)
    );
    
    BCD_Digit thousands_digit (
        .clk(clk),
        .reset(reset),
        .enable(rollover_hundreds),
        .value(thousands),
        .rollover()  // Not needed for thousands digit
    );
    
    // Assign outputs
    assign q = {thousands, hundreds, tens, ones};
    assign ena = {rollover_hundreds, rollover_tens, rollover_ones};

endmodule