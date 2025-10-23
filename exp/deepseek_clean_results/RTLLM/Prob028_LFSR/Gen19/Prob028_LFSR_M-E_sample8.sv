module LFSR (
    input clk,
    input rst,
    output reg [3:0] out,
    output reg [3:0] next_out
);

reg feedback_invert;
wire feedback = out[3] ^ out[2] ^ feedback_invert;

// Rising edge operation
always @(posedge clk or posedge rst) begin
    if (rst) begin
        out <= 4'b0001;
        feedback_invert <= 1'b0;
    end
    else begin
        // Toggle feedback inversion every cycle
        feedback_invert <= ~feedback_invert;
        
        // Auto-reseed if state becomes zero
        if (out == 4'b0000)
            out <= 4'b0001;
    end
end

// Falling edge operation - generates next_out
always @(negedge clk) begin
    next_out <= {out[2:0], feedback};
    
    // Update main output on falling edge too
    out <= {out[2:0], feedback};
end

endmodule

// Enhanced Testbench
module LFSR_tb;
    reg clk;
    reg rst;
    wire [3:0] out;
    wire [3:0] next_out;
    
    LFSR dut (
        .clk(clk),
        .rst(rst),
        .out(out),
        .next_out(next_out)
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
        $monitor("Time=%0t out=%4b next_out=%4b", $time, out, next_out);
    end
endmodule