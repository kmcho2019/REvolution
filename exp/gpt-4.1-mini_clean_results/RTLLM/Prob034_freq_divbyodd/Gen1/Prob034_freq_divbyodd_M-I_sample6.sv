module freq_divbyodd #(parameter NUM_DIV = 5) (
    input  wire clk,
    input  wire rst_n,
    output reg  clk_div
);

    // Assert NUM_DIV is odd and >= 3
    initial begin
        if (NUM_DIV < 3 || (NUM_DIV % 2) == 0) begin
            $error("NUM_DIV must be an odd number >= 3");
        end
    end

    // Counter width depends on NUM_DIV
    localparam CNT_WIDTH = $clog2(NUM_DIV*2); 
    reg [CNT_WIDTH-1:0] cnt;

    // Double data rate counting: increment cnt on every edge (posedge and negedge)
    // This effectively creates a clock of 2x frequency for the counter,
    // allowing toggling every NUM_DIV counts to get the desired odd division.

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt <= 0;
            clk_div <= 0;
        end else begin
            if (cnt == NUM_DIV - 1) begin
                cnt <= 0;
                clk_div <= ~clk_div;
            end else begin
                cnt <= cnt + 1;
            end
        end
    end

    always @(negedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt <= 0;
            clk_div <= 0;
        end else begin
            if (cnt == NUM_DIV - 1) begin
                cnt <= 0;
                clk_div <= ~clk_div;
            end else begin
                cnt <= cnt + 1;
            end
        end
    end

endmodule