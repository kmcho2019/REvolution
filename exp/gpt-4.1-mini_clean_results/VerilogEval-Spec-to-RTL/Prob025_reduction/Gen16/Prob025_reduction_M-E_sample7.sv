// TopModule computes even parity of an 8-bit input using an explicit XOR tree
module TopModule (
    input  [7:0] in,
    output       parity
);
    wire x1, x2, x3, x4;
    wire y1, y2;

    // Level 1: XOR adjacent bits
    assign x1 = in[0] ^ in[1];
    assign x2 = in[2] ^ in[3];
    assign x3 = in[4] ^ in[5];
    assign x4 = in[6] ^ in[7];

    // Level 2: XOR outputs from level 1
    assign y1 = x1 ^ x2;
    assign y2 = x3 ^ x4;

    // Level 3: final parity bit
    assign parity = y1 ^ y2;
endmodule

// Simple testbench to verify parity calculation correctness
module tb_TopModule;
    reg  [7:0] in;
    wire       parity;

    TopModule dut (
        .in(in),
        .parity(parity)
    );

    initial begin
        $display("Input      Expected Parity  DUT Parity");
        // Test some representative values
        in = 8'b00000000; #1;
        $display("%b  %b               %b", in, ^in, parity);

        in = 8'b11111111; #1;
        $display("%b  %b               %b", in, ^in, parity);

        in = 8'b10101010; #1;
        $display("%b  %b               %b", in, ^in, parity);

        in = 8'b01010101; #1;
        $display("%b  %b               %b", in, ^in, parity);

        in = 8'b00001111; #1;
        $display("%b  %b               %b", in, ^in, parity);

        in = 8'b00110011; #1;
        $display("%b  %b               %b", in, ^in, parity);

        // Check all inputs exhaustively for correctness
        integer i;
        for (i = 0; i < 256; i = i + 1) begin
            in = i[7:0];
            #1;
            if (parity !== (^in)) begin
                $display("Mismatch at input %b: expected %b, got %b", in, ^in, parity);
                $stop;
            end
        end
        $display("All inputs matched expected parity.");
        $finish;
    end
endmodule