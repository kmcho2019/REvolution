module LFSR (
    input wire clk,            // Clock input
    input wire arst_n,         // Active-low asynchronous reset
    input wire load,           // Parallel load enable
    input wire [1:0] fb_sel,   // Feedback polynomial select
    input wire [3:0] seed,     // Parallel load seed value
    output reg [3:0] out,      // 4-bit LFSR state output
    output wire max_cycle      // Pulses when cycle completes
);

// Internal signals
reg [3:0] next_state;
wire feedback;
reg [3:0] initial_state;

// Store initial state for cycle detection
always @(posedge clk or negedge arst_n) begin
    if (!arst_n) begin
        initial_state <= 4'b0001;
    end else if (load) begin
        initial_state <= seed;
    end
end

// Feedback polynomial selection
assign feedback = 
    (fb_sel == 2'b00) ? out[3] ^ out[2] :       // x^4 + x^3 + 1
    (fb_sel == 2'b01) ? out[3] ^ out[1] :       // x^4 + x^2 + 1
    out[3] ^ out[0];                            // x^4 + x^1 + 1

// Next state logic
always @(*) begin
    if (load) begin
        next_state = seed;
    end else begin
        next_state = {out[2:0], feedback};
    end
end

// State register with async reset
always @(posedge clk or negedge arst_n) begin
    if (!arst_n) begin
        out <= 4'b0001;
    end else begin
        out <= next_state;
    end
end

// Cycle completion detection
assign max_cycle = (out == initial_state) && !load;

endmodule

module LFSR_tb;

reg clk_tb;
reg arst_n_tb;
reg load_tb;
reg [1:0] fb_sel_tb;
reg [3:0] seed_tb;
wire [3:0] out_tb;
wire max_cycle_tb;

// Instantiate the LFSR
LFSR dut (
    .clk(clk_tb),
    .arst_n(arst_n_tb),
    .load(load_tb),
    .fb_sel(fb_sel_tb),
    .seed(seed_tb),
    .out(out_tb),
    .max_cycle(max_cycle_tb)
);

// Clock generation
initial begin
    clk_tb = 0;
    forever #5 clk_tb = ~clk_tb;
end

// Test sequence
initial begin
    // Initialize with async reset
    arst_n_tb = 0;
    load_tb = 0;
    fb_sel_tb = 2'b00;
    seed_tb = 4'b0000;
    #20;
    
    // Release reset
    arst_n_tb = 1;
    
    // Test default polynomial (x^4 + x^3 + 1)
    $display("Testing polynomial x^4 + x^3 + 1");
    #200;
    
    // Load new seed
    seed_tb = 4'b1001;
    load_tb = 1;
    #10;
    load_tb = 0;
    $display("Loaded new seed: 1001");
    #200;
    
    // Test different polynomial (x^4 + x^2 + 1)
    fb_sel_tb = 2'b01;
    $display("Testing polynomial x^4 + x^2 + 1");
    #200;
    
    // End simulation
    $display("Simulation complete");
    $finish;
end

// Monitor the output
initial begin
    $monitor("Time = %0t, State = %b, Max Cycle = %b", 
             $time, out_tb, max_cycle_tb);
end

endmodule