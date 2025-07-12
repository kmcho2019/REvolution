module freq_divbyfrac (
    input  wire clk,
    input  wire rst_n,
    output wire clk_div
);

// Define parameters for 3.5x division
parameter MUL2_DIV_CLK = 7; // Total cycles for 3.5x division
parameter CYCLES_HIGH  = 4; // Number of cycles for high phase
parameter CYCLES_LOW   = 3; // Number of cycles for low phase

// Internal signals
reg [2:0]  counter; // Counter for cycle tracking
reg        clk_int; // Intermediate clock signal
reg        clk_int_d; // Delayed intermediate clock signal
reg        clk_int_a; // Advanced intermediate clock signal

// Counter logic
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        counter <= 3'b000;
        clk_int <= 1'b0;
    end else if (counter == MUL2_DIV_CLK - 1) begin
        counter <= 3'b000;
        clk_int <= ~clk_int;
    end else begin
        counter <= counter + 1'b1;
        if (counter < CYCLES_HIGH) begin
            clk_int <= 1'b1;
        end else begin
            clk_int <= 1'b0;
        end
    end
end

// Double-edge clocking and phase shifting
always @(posedge clk) begin
    clk_int_d <= clk_int;
end

always @(negedge clk) begin
    clk_int_a <= clk_int;
end

// Final clock generation
assign clk_div = clk_int | clk_int_d | clk_int_a;

endmodule