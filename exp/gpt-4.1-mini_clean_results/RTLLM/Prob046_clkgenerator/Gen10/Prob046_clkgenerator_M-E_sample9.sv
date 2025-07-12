module clkgenerator #(parameter PERIOD = 10) (
    input  wire clk_in,
    output reg  clk
);

    // Calculate half period, minimum 1 to avoid zero divide
    localparam integer HALF_PERIOD = (PERIOD < 2) ? 1 : (PERIOD / 2);

    // Width of counter to hold HALF_PERIOD
    localparam integer COUNTER_WIDTH = $clog2(HALF_PERIOD);

    reg [COUNTER_WIDTH-1:0] counter = 0;

    // Synchronous logic for clock division
    always @(posedge clk_in) begin
        if (counter == HALF_PERIOD - 1) begin
            counter <= 0;
            clk <= ~clk;
        end else begin
            counter <= counter + 1;
        end
    end

    // Optional initial block to set clk initial value to 0
    initial begin
        clk = 0;
    end

endmodule