module barrel_shifter(
    input         clk,  // Clock input for clock gating
    input         en,   // Enable signal for clock gating
    input  [7:0] in,   // Input to be shifted
    input  [2:0] ctrl,  // Control signal
    output [7:0] out    // Shifted output
);

    wire [7:0] stage1_out;
    wire [7:0] stage2_out;
    wire [7:0] stage3_out;

    // Stage 1: Shift by 4 positions if ctrl[2] is high
    assign stage1_out = (ctrl[2]) ? (in >> 4) : in;

    // Stage 2: Shift by 2 positions if ctrl[1] is high
    assign stage2_out = (ctrl[1]) ? (stage1_out >> 2) : stage1_out;

    // Stage 3: Shift by 1 position if ctrl[0] is high
    assign stage3_out = (ctrl[0]) ? (stage2_out >> 1) : stage2_out;

    // Output assignment with clock gating
    reg [7:0] out_reg;
    always @ (posedge clk) begin
        if (en) begin
            out_reg <= stage3_out;
        end
    end
    assign out = out_reg;

endmodule

module barrel_shifter_testbench;
    reg         clk;
    reg         en;
    reg  [7:0] in;
    reg  [2:0] ctrl;
    wire [7:0] out;

    barrel_shifter uut (
       .clk(clk),
       .en(en),
       .in(in),
       .ctrl(ctrl),
       .out(out)
    );

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars;
        
        // Initialize signals
        clk = 0;
        en = 1;
        in = 8'b11010011;
        ctrl = 3'b000;
        
        // Test all possible combinations of control bits
        forever begin
            #10;
            clk = ~clk;
            for (int i = 0; i < 8; i++) begin
                ctrl = i;
                #20;
                $display("Output for ctrl = %b: %b", ctrl, out);
            end

            // Test with varying inputs and control signals
            for (int i = 0; i < 256; i++) begin
                in = i;
                for (int j = 0; j < 8; j++) begin
                    ctrl = j;
                    #20;
                    $display("Output for in = %b, ctrl = %b: %b", in, ctrl, out);
                end
            end

            // Disable the module to test power reduction
            en = 0;
            #20;
            $display("Module disabled. Output should remain constant.");
            #20;
            en = 1;
        end
    end
endmodule