`timescale 1ns / 1ps

module clkgenerator #(parameter PERIOD = 10) (
    output reg clk
);

localparam integer HALF_PERIOD = PERIOD / 2;

reg toggle_event;

// Initialize clock and event
initial begin
    clk = 0;
    toggle_event = 0;
    forever begin
        #HALF_PERIOD toggle_event = ~toggle_event;
    end
end

// Toggle clock on event edge
always @(posedge toggle_event) begin
    clk <= ~clk;
end

endmodule