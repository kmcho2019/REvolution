// Novel two-stage frequency divider module by even numbers
module freq_div_new #(
    parameter NUM_DIV = 4  // Even number division factor
) (
    input logic clk,      // Input clock signal
    input logic rst_n,    // Active-low reset signal
    output logic clk_div  // Divided clock output signal
);

// Validate NUM_DIV as an even number and greater than 1 at compile-time
initial begin
    if (NUM_DIV % 2 != 0 || NUM_DIV < 2) begin
        $error("NUM_DIV must be an even number greater than 1.");
        $finish;
    end
end

// Stage 1: Simple toggle flip-flop for division by 2
logic stage1_clk;

// Sequential logic for stage 1
always_ff @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        stage1_clk <= 0;
    end else begin
        stage1_clk <= ~stage1_clk;
    end
end

// Stage 2: Counter-based division by NUM_DIV / 2
logic [2:0] stage2_cnt;  // Counter for stage 2

// Sequential logic for stage 2
always_ff @(posedge stage1_clk or negedge rst_n) begin
    if (~rst_n) begin
        stage2_cnt <= 0;
        clk_div <= 0;
    end else if (stage2_cnt == (NUM_DIV / 2 - 1)) begin
        stage2_cnt <= 0;
        clk_div <= ~clk_div;
    end else begin
        stage2_cnt <= stage2_cnt + 1;
    end
end

endmodule

// Testbench for the novel two-stage frequency divider module
module freq_div_new_tb;
    logic clk;
    logic rst_n;
    wire clk_div;

    freq_div_new #(.NUM_DIV(4)) uut (
        .clk(clk),
        .rst_n(rst_n),
        .clk_div(clk_div)
    );

    initial begin
        clk = 0;
        rst_n = 1;
        #10 rst_n = 0;
        #10 rst_n = 1;
        #100 $finish;
    end

    always #5 clk = ~clk;

    initial begin
        $dumpfile("freq_div_new.vcd");
        $dumpvars(0, freq_div_new_tb);
    end
endmodule