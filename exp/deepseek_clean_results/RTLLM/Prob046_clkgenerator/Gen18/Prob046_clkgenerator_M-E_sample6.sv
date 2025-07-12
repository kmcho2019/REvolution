module clkgenerator #(
    parameter PERIOD = 10,          // Total clock period
    parameter DUTY_CYCLE = 50       // Duty cycle percentage (0-100)
)(
    output reg clk,
    input reset_n                    // Optional active-low reset
);

    localparam HIGH_TIME = (PERIOD * DUTY_CYCLE) / 100;
    localparam LOW_TIME = PERIOD - HIGH_TIME;
    reg [31:0] counter;

    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            counter <= 0;
            clk <= 0;
        end else begin
            if (counter >= PERIOD-1)
                counter <= 0;
            else
                counter <= counter + 1;

            if (counter < HIGH_TIME)
                clk <= 1;
            else
                clk <= 0;
        end
    end

    // Initialization for simulation
    initial begin
        clk = 0;
        counter = 0;
    end
endmodule