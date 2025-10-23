module clock_counter #(
    parameter PERIOD = 10
)(
    input clk,
    input reset,
    output reg toggle
);

reg [31:0] counter;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        counter <= 0;
        toggle <= 0;
    end else if (counter == (PERIOD / 2 - 1)) begin
        counter <= 0;
        toggle <= 1;
    end else begin
        counter <= counter + 1;
        toggle <= 0;
    end
end

endmodule

module clkgenerator #(
    parameter PERIOD = 10
)(
    output reg clk,
    input reset
);

reg toggle;

clock_counter #(.PERIOD(PERIOD)) counter_instance(
    .clk(clk),
    .reset(reset),
    .toggle(toggle)
);

always @(posedge toggle or posedge reset) begin
    if (reset) begin
        clk <= 0;
    end else begin
        clk <= ~clk;
    end
end

initial begin
    clk = 0;
end

endmodule