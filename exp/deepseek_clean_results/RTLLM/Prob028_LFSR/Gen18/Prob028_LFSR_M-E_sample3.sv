module LFSR #(
    parameter WIDTH = 4,
    parameter FEEDBACK_TAPS = 4'b1100  // Default taps for bits 3 and 2
)(
    input clk,
    input rst,
    input load_en,
    input [WIDTH-1:0] seed,
    output reg [WIDTH-1:0] out
);

wire feedback;

// Calculate feedback based on selected taps
assign feedback = ^(out & FEEDBACK_TAPS);

always @(posedge clk) begin
    if (rst) begin
        out <= {1'b1, {(WIDTH-1){1'b0}}}; // Default to 1 at MSB
    end
    else if (load_en) begin
        out <= seed;
    end
    else begin
        out <= {out[WIDTH-2:0], feedback};
    end
end

endmodule

module LFSR_tb;
    localparam WIDTH = 4;
    reg clk = 0;
    reg rst = 1;
    reg load_en = 0;
    reg [WIDTH-1:0] seed = 4'b1010;
    wire [WIDTH-1:0] out;

    LFSR #(.WIDTH(WIDTH)) dut (
        .clk(clk),
        .rst(rst),
        .load_en(load_en),
        .seed(seed),
        .out(out)
    );

    always #5 clk = ~clk;

    initial begin
        #10 rst = 0;
        #20 load_en = 1;
        #10 load_en = 0;
        #100 $finish;
    end

    initial begin
        $monitor("Time=%0t: out=%b", $time, out);
    end
endmodule