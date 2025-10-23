// Define the barrel_shifter module
module barrel_shifter(
    input [7:0] in,   // 8-bit input to be shifted
    input [2:0] ctrl, // 3-bit control signal
    output [7:0] out   // 8-bit shifted output
);

    // Calculate the shifted output
    wire [7:0] shift4 = {in[3:0], 4'b0000}; // Shift in by 4 positions
    wire [7:0] shift2 = {in[5:0], 2'b00}; // Shift in by 2 positions
    wire [7:0] shift1 = {in[6:0], 1'b0}; // Shift in by 1 position

    // Use conditional statements to select the shifted output
    assign out = (ctrl[2] ? (ctrl[1] ? (ctrl[0] ? {shift4[5:0], shift4[7], shift1[7]} : {shift4[6:0], shift2[7]}) : (ctrl[0] ? {shift2[6:0], shift1[7]} : shift2)) : 
                 (ctrl[1] ? (ctrl[0] ? shift1 : shift2) : (ctrl[0] ? shift1 : in));

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
        ctrl = 3'b001;
        #10;
        $display("Output: %b", out);
    end
endmodule