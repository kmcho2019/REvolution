module LFSR (
    input wire clk,
    input wire rst,
    output reg [3:0] out,
    output wire [3:0] next_out
);

// Polynomial rotation counter
reg [2:0] poly_counter;

// Feedback calculation
wire feedback;
always @(*) begin
    case (poly_counter[1:0])
        2'b00: feedback = ~(out[3] ^ out[2]);  // x^4 + x^3 + 1
        2'b01: feedback = ~(out[3] ^ out[0]);  // x^4 + x + 1
        2'b10: feedback = ~(out[3] ^ out[2] ^ out[1] ^ out[0]); // x^4 + x^3 + x^2 + x + 1
        2'b11: feedback = ~(out[3] ^ out[1]); // x^4 + x^2 + 1
    endcase
end

// Next state calculation (combinational)
assign next_out = (out == 4'b0000) ? 4'b0001 : {out[2:0], feedback};

// Sequential logic
always @(posedge clk) begin
    if (rst) begin
        out <= 4'b0001; // Simple non-zero initialization
        poly_counter <= 0;
    end else begin
        out <= next_out;
        poly_counter <= poly_counter + 1;
    end
end

endmodule

module LFSR_tb;

reg clk;
reg rst;
wire [3:0] out;
wire [3:0] next_out;

// Correct instantiation with all ports
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

// Test sequence
initial begin
    rst = 1;
    #20;
    
    rst = 0;
    $display("LFSR initialized to: %b", out);
    
    #200;
    
    rst = 1;
    #10;
    rst = 0;
    $display("LFSR reset to: %b", out);
    
    #100;
    $finish;
end

// Monitor
initial begin
    $monitor("Time = %0t: State = %b, Next = %b", $time, out, next_out);
end

endmodule