// Define the barrel_shifter module
module barrel_shifter(
    input [7:0] in,  // Input to be shifted
    input [2:0] ctrl,  // Control signal
    output [7:0] out  // Shifted output
);

    // Calculate the total shift amount based on the control signal
    wire [2:0] shift_amount = ctrl;
    
    // Directly shift the input by the calculated amount
    wire [7:0] shifted_in = in << shift_amount;
    
    // Assign the final output, handling wrap-around for circular shift
    assign out = {shifted_in[7 - shift_amount:0], shifted_in[7:7 - shift_amount + 1]};

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
        $dumpfile("dump.vcd");
        $dumpvars;
        
        // Test cases for different control signal values
        in = 8'b11010011;
        for (int i = 0; i < 8; i++) begin
            ctrl = i;
            #10;
            $display("Output for ctrl = %b: %b", ctrl, out);
        end

        #10;
        $finish;
    end
endmodule