module TopModule(
    input clk,
    input [7:0] in,
    output reg [7:0] pedge
);

reg [7:0] prev_in; // Register to hold the previous state of in

always @(posedge clk) begin
    pedge <= 8'b0; // Initialize pedge to 0 at the start of each cycle
    pedge <= ~prev_in & in; // Set pedge bits where in has gone from 0 to 1
    prev_in <= in; // Update prev_in for the next cycle
end

endmodule