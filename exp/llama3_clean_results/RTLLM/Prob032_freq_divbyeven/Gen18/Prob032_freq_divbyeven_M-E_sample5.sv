// Frequency divider module by even numbers
module freq_diveven #(
    parameter NUM_DIV = 4  // Even number division factor
) (
    input clk,        // Input clock signal
    input rst_n,      // Active-low reset signal
    output reg clk_div // Divided clock output signal
);

// Validate NUM_DIV as an even number and greater than 1 at compile-time
initial begin
    if (NUM_DIV % 2 != 0 || NUM_DIV < 2) begin
        $error("NUM_DIV must be an even number greater than 1.");
        $finish;
    end
end

reg [3:0] cnt;    // Counter for clock cycle counting
reg [1:0] state;  // State machine states: COUNT (0) and RESET (1)

// Sequential logic for state machine and counter update
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cnt <= 0;
        state <= 0;
        clk_div <= 0;
    end else begin
        case (state)
            0: begin  // COUNT state
                if (cnt == (NUM_DIV / 2 - 1)) begin
                    cnt <= 0;
                    state <= 1;  // Move to RESET state
                    clk_div <= ~clk_div;
                end else begin
                    cnt <= cnt + 1;
                end
            end
            1: begin  // RESET state
                state <= 0;  // Move back to COUNT state
            end
        endcase
    end
end

endmodule

// Testbench for the frequency divider module
module freq_diveven_tb;
    reg clk;
    reg rst_n;
    wire clk_div;

    freq_diveven #(.NUM_DIV(4)) uut (
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
        $dumpfile("freq_diveven.vcd");
        $dumpvars(0, freq_diveven_tb);
    end
endmodule