// Define the barrel_shifter module
module barrel_shifter(
    input [7:0] in,  // Input to be shifted
    input [2:0] ctrl,  // Control signal
    output reg [7:0] out  // Shifted output
);
    always @(*) begin
        reg [2:0] shift_amount;
        shift_amount = {ctrl[2], ctrl[1], ctrl[0]};
        out = in;
        if (ctrl[2]) out = {in[3:0], in[7:4]};
        if (ctrl[1]) out = {out[5:0], out[7:6]};
        if (ctrl[0]) out = {out[6:0], out[7]};
    end
endmodule

// Testbench for the barrel_shifter module
module barrel_shifter_testbench;
    reg [7:0] in;
    reg [2:0] ctrl;
    wire [7:0] out;

    barrel_shifter uut (
      .in(in),
      .ctrl(ctrl),
      .out(out)
    );

    initial begin
        in = 8'b11010011;
        ctrl = 3'b000;  // Test no shift
        #10;
        $display("Output (no shift): %b", out);

        in = 8'b11010011;
        ctrl = 3'b001;  // Test shift by 1
        #10;
        $display("Output (shift by 1): %b", out);

        in = 8'b11010011;
        ctrl = 3'b010;  // Test shift by 2
        #10;
        $display("Output (shift by 2): %b", out);

        in = 8'b11010011;
        ctrl = 3'b100;  // Test shift by 4
        #10;
        $display("Output (shift by 4): %b", out);

        in = 8'b11010011;
        ctrl = 3'b101;  // Test shift by 5
        #10;
        $display("Output (shift by 5): %b", out);

        in = 8'b11010011;
        ctrl = 3'b110;  // Test shift by 6
        #10;
        $display("Output (shift by 6): %b", out);

        in = 8'b11010011;
        ctrl = 3'b111;  // Test shift by 7
        #10;
        $display("Output (shift by 7): %b", out);
    end
endmodule