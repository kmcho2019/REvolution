module LFSR (
    input clk,
    input rst,
    output [3:0] out
);

reg [3:0] state;
wire feedback = ~(state[3] ^ state[2]);

// Continuous output assignment
assign out = state;

// State update logic
always @(posedge clk or posedge rst) begin
    if (rst) begin
        state <= 4'b0000;
    end
    else begin
        state <= {state[2:0], feedback};
    end
end

endmodule

// Testbench
module LFSR_tb;
    reg clk;
    reg rst;
    wire [3:0] out;
    
    LFSR dut (
        .clk(clk),
        .rst(rst),
        .out(out)
    );
    
    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end
    
    // Stimulus
    initial begin
        rst = 1;
        #15 rst = 0;
        #200 $finish;
    end
    
    // Monitoring
    initial begin
        $monitor("Time=%0t out=%4b", $time, out);
    end
endmodule