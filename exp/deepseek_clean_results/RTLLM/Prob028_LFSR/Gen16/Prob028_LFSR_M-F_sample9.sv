module LFSR (
    input clk,
    input rst,
    output reg [3:0] out
);

wire feedback;
assign feedback = ~(out[3] ^ out[2]);

always @(posedge clk) begin
    if (rst) begin
        out <= 4'b0001;
    end
    else begin
        out <= {out[2:0], feedback};
    end
end

endmodule

module LFSR_tb;

reg clk_tb;
reg rst_tb;
wire [3:0] out_tb;

// Instantiate DUT
LFSR dut (
    .clk(clk_tb),
    .rst(rst_tb),
    .out(out_tb)
);

// Clock generation
initial begin
    clk_tb = 0;
    forever #5 clk_tb = ~clk_tb;
end

// Stimulus
initial begin
    rst_tb = 1; // Assert reset
    #20 rst_tb = 0; // Release reset
    #100 $display("Simulation complete");
    $finish;
end

// Monitor
always @(posedge clk_tb) begin
    $display("Time=%0t out=%4b", $time, out_tb);
end

endmodule