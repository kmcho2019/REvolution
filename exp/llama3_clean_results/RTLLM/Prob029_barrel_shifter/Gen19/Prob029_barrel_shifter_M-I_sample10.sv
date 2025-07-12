// Define the barrel_shifter module with clock gating
module barrel_shifter(
    input clk,  // Clock signal
    input rst_n,  // Active low reset
    input [7:0] in,  // Input to be shifted
    input [2:0] ctrl,  // Control signal
    input enable,  // Enable signal for clock gating
    output [7:0] out  // Shifted output
);

    // Internal signal for clock-gated clock
    wire clk_gated;

    // Clock gating logic
    assign clk_gated = enable ? clk : 1'b0;

    // Register to hold the output
    reg [7:0] out_reg;

    // Calculate the total shift amount directly from control bits
    always @(posedge clk_gated or negedge rst_n) begin
        if (!rst_n) begin
            out_reg <= 8'b0;
        end else begin
            out_reg <= (in >> (ctrl[2] * 4 + ctrl[1] * 2 + ctrl[0]));
        end
    end

    // Output assignment
    assign out = out_reg;

endmodule

// Comprehensive testbench with clock and reset
module barrel_shifter_testbench;
    reg clk;
    reg rst_n;
    reg [7:0] in;
    reg [2:0] ctrl;
    reg enable;
    wire [7:0] out;

    barrel_shifter uut (
        .clk(clk),
        .rst_n(rst_n),
        .in(in),
        .ctrl(ctrl),
        .enable(enable),
        .out(out)
    );

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars;
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        rst_n = 0;
        in = 8'b11010011;
        ctrl = 3'b000;  // Test no shift
        enable = 1'b1;  // Enable the barrel shifter
        #10;
        rst_n = 1;
        $display("Output (no shift): %b", out);

        #10;
        ctrl = 3'b001;  // Test shift by 1
        #10;
        $display("Output (shift by 1): %b", out);

        #10;
        ctrl = 3'b010;  // Test shift by 2
        #10;
        $display("Output (shift by 2): %b", out);

        #10;
        ctrl = 3'b100;  // Test shift by 4
        #10;
        $display("Output (shift by 4): %b", out);

        #10;
        ctrl = 3'b011;  // Test shift by 3 (1+2)
        #10;
        $display("Output (shift by 3): %b", out);

        #10;
        ctrl = 3'b101;  // Test shift by 5 (1+4)
        #10;
        $display("Output (shift by 5): %b", out);

        #10;
        ctrl = 3'b110;  // Test shift by 6 (2+4)
        #10;
        $display("Output (shift by 6): %b", out);

        #10;
        ctrl = 3'b111;  // Test shift by 7 (1+2+4)
        #10;
        $display("Output (shift by 7): %b", out);

        // Additional test cases for comprehensive coverage
        in = 8'b11010011;
        ctrl = 3'b000;  // Test no shift with different input
        in = 8'b10101010;
        #10;
        $display("Output (no shift, different input): %b", out);

        // Test all possible combinations of control bits
        for (int i = 0; i < 8; i++) begin
            ctrl = i;
            #10;
            $display("Output for ctrl = %b: %b", ctrl, out);
        end

        // Test with varying inputs and control signals
        for (int i = 0; i < 256; i++) begin
            in = i;
            for (int j = 0; j < 8; j++) begin
                ctrl = j;
                #10;
                $display("Output for in = %b, ctrl = %b: %b", in, ctrl, out);
            end
        end

        #10;
        $finish;
    end
endmodule