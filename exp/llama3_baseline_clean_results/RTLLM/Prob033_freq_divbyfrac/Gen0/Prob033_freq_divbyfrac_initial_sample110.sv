module freq_divbyfrac(
    input clk,    // Input clock signal
    input rst_n,  // Active low reset signal
    output reg clk_div  // Fractionally divided clock output
);

// Counter to cycle through 7 clock cycles for 3.5x division
reg [2:0] cnt;

// Signals to generate uneven clock periods
reg clk_div_int;  // Intermediate divided clock signal
reg clk_div_int_delayed;  // Delayed version of the intermediate clock
reg clk_div_int_advanced;  // Advanced version of the intermediate clock

// Counter logic
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cnt <= 3'b000;
        clk_div_int <= 1'b0;
        clk_div_int_delayed <= 1'b0;
        clk_div_int_advanced <= 1'b0;
        clk_div <= 1'b0;
    end else begin
        if (cnt == 3'b110) begin  // 7 clock cycles (3.5x division)
            cnt <= 3'b000;
            clk_div_int <= ~clk_div_int;
        end else begin
            cnt <= cnt + 1'b1;
        end

        // Generate uneven clock periods
        if (cnt == 3'b100 || cnt == 3'b011) begin
            clk_div_int_delayed <= ~clk_div_int_delayed;
        end
        if (cnt == 3'b010 || cnt == 3'b101) begin
            clk_div_int_advanced <= ~clk_div_int_advanced;
        end
    end
end

// Generate phase-shifted versions of the intermediate clock
always @(posedge clk) begin
    // Delayed version of the intermediate clock
    if (cnt == 3'b001 || cnt == 3'b100) begin
        clk_div_int_delayed <= ~clk_div_int;
    end

    // Advanced version of the intermediate clock
    if (cnt == 3'b011 || cnt == 3'b110) begin
        clk_div_int_advanced <= ~clk_div_int;
    end
end

// Final fractional divided clock output
always @(posedge clk) begin
    // Logically OR the phase-shifted versions of the intermediate clocks
    clk_div <= clk_div_int_delayed | clk_div_int_advanced;
end

endmodule