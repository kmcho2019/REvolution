module LFSR_advanced #(
    parameter WIDTH = 4,
    parameter POLY = 4'b1101  // x^4 + x^3 + x^2 + x + 1
)(
    input clk,
    input rst,
    input load,
    input [WIDTH-1:0] seed,
    output reg [WIDTH-1:0] out,
    output reg sequence_done
);

reg [WIDTH-1:0] next_state;
reg [15:0] cycle_count;  // Track sequence completion

// Feedback calculation using parallel polynomial
always @(*) begin
    next_state = {out[WIDTH-2:0], 1'b0};  // Basic shift
    if (out[WIDTH-1]) begin
        next_state = next_state ^ POLY;    // XOR with polynomial
    end
end

// Sequence completion detection
always @(posedge clk) begin
    if (rst) begin
        cycle_count <= 0;
        sequence_done <= 0;
    end else if (out == seed && cycle_count != 0) begin
        sequence_done <= 1;
    end else begin
        cycle_count <= cycle_count + 1;
    end
end

// Main state register
always @(posedge clk) begin
    if (rst) begin
        out <= 4'b0001;  // Default non-zero state
    end else if (load) begin
        out <= seed;     // Load external seed
    end else begin
        out <= next_state;  // Parallel update
    end
end

endmodule

module LFSR_advanced_tb;

reg clk;
reg rst;
reg load;
reg [3:0] seed;
wire [3:0] out;
wire sequence_done;

LFSR_advanced dut (
    .clk(clk),
    .rst(rst),
    .load(load),
    .seed(seed),
    .out(out),
    .sequence_done(sequence_done)
);

// Clock generation
initial begin
    clk = 0;
    forever #5 clk = ~clk;
end

// Stimulus
initial begin
    rst = 1;
    load = 0;
    seed = 4'b0000;
    
    // Reset sequence
    #20 rst = 0;
    
    // Observe default sequence
    #150;
    
    // Test seed loading
    load = 1;
    seed = 4'b1010;
    #10 load = 0;
    
    // Run until sequence completes
    wait(sequence_done);
    $display("Sequence completed at time %0t", $time);
    $finish;
end

// Monitor
initial begin
    $monitor("Time=%0t out=%4b done=%b", $time, out, sequence_done);
end

endmodule