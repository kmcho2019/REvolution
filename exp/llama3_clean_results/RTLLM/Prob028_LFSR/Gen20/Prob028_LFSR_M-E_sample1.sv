// Modular LFSR implementation
module ModularLFSR(
    parameter           WIDTH = 4,  // Parameterizable bit width
    input               clk,       // Clock signal
    input               rst,       // Active high reset signal
    input               clk_en,    // Clock enable signal
    output reg [WIDTH-1:0] out     // Output representing the current state of the LFSR
);

// Circular buffer to store the current state
reg [WIDTH-1:0] state;

// Initialize the state on reset
always @(posedge clk or posedge rst) begin
    if (rst) begin
        state <= {WIDTH{1'b0}};  // Reset to zero
    end else if (clk_en) begin
        // Calculate feedback as XOR of MSB and second MSB
        reg [WIDTH-1:0] next_state;
        next_state[WIDTH-1] = state[WIDTH-2] ^ state[WIDTH-3];
        next_state[WIDTH-2:0] = state[WIDTH-1:1];
        state <= next_state;
    end
end

// Assign the output
always @(*) begin
    out = state;
end

endmodule

// Testbench for ModularLFSR
module ModularLFSR_test;
    parameter           WIDTH = 4;
    reg                 clk;
    reg                 rst;
    reg                 clk_en;
    wire [WIDTH-1:0]     out;

    // Instantiate the ModularLFSR module
    ModularLFSR #(.WIDTH(WIDTH)) uut(
       .clk(clk),
       .rst(rst),
       .clk_en(clk_en),
       .out(out)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Test sequence
    initial begin
        rst = 1;
        clk_en = 0;
        #10;
        rst = 0;
        clk_en = 1;
        #100;
        $finish;
    end

    // Monitor the output
    initial begin
        $monitor("out = %b", out);
    end
endmodule