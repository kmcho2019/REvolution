module freq_diveven #(
    parameter integer NUM_DIV = 4  // Must be even and >= 2
) (
    input  wire clk,
    input  wire rst_n,
    output reg  clk_div
);

    // Runtime check for valid NUM_DIV
    initial begin
        if ((NUM_DIV < 2) || (NUM_DIV % 2) != 0) begin
            $display("ERROR: NUM_DIV must be even and >= 2 (got %0d)", NUM_DIV);
            $finish;
        end
    end

    // Function to calculate bit width needed for NUM_DIV-1
    function integer clog2;
        input integer value;
        integer i;
        begin
            clog2 = 0;
            for (i = value - 1; i > 0; i = i >> 1)
                clog2 = clog2 + 1;
        end
    endfunction

    localparam integer CNT_WIDTH = clog2(NUM_DIV);

    reg [CNT_WIDTH-1:0] cnt;

    wire toggle_clk = (cnt == (NUM_DIV >> 1) - 1);

    // Counter increments every clock, resets at NUM_DIV -1
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt <= 0;
        end else if (cnt == NUM_DIV - 1) begin
            cnt <= 0;
        end else begin
            cnt <= cnt + 1;
        end
    end

    // clk_div toggles on toggle_clk signal
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            clk_div <= 0;
        end else if (toggle_clk) begin
            clk_div <= ~clk_div;
        end
    end

endmodule