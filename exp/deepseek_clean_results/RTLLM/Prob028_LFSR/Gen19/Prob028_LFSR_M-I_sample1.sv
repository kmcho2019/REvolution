module LFSR (
    input clk,
    input rst,
    output reg [3:0] out
);

wire feedback;

// Feedback as specified: XOR of bits 3 and 2, then inverted
assign feedback = ~(out[3] ^ out[2]);

always @(posedge clk) begin
    if (rst) begin
        out <= 4'b0000; // Initialize to zero as specified
    end
    else begin
        out <= {out[2:0], feedback};
    end
end

endmodule

module LFSR_tb;
    reg clk = 0;
    reg rst = 1;
    wire [3:0] out;

    LFSR dut (
        .clk(clk),
        .rst(rst),
        .out(out)
    );

    always #5 clk = ~clk;

    initial begin
        $monitor("Time=%0t: out=%4b", $time, out);
        #10 rst = 0;
        #200 $finish;
    end

    // Sequence verification
    reg [3:0] expected_sequence [0:14];
    integer i;

    initial begin
        // Expected maximal-length sequence for this LFSR configuration
        expected_sequence[0] = 4'b0000;
        expected_sequence[1] = 4'b0001;
        expected_sequence[2] = 4'b0011;
        expected_sequence[3] = 4'b0110;
        expected_sequence[4] = 4'b1101;
        expected_sequence[5] = 4'b1011;
        expected_sequence[6] = 4'b0111;
        expected_sequence[7] = 4'b1111;
        expected_sequence[8] = 4'b1110;
        expected_sequence[9] = 4'b1100;
        expected_sequence[10] = 4'b1001;
        expected_sequence[11] = 4'b0010;
        expected_sequence[12] = 4'b0100;
        expected_sequence[13] = 4'b1000;
        expected_sequence[14] = 4'b0001;

        for (i = 0; i < 15; i = i + 1) begin
            @(posedge clk);
            if (out !== expected_sequence[i]) begin
                $display("Error at cycle %0d: Expected %4b, Got %4b", 
                         i, expected_sequence[i], out);
            end
        end
    end
endmodule