module freq_divbyodd #(
    parameter NUM_DIV = 5  // Must be odd number
) (
    input wire clk,
    input wire rst_n,
    output reg clk_div
);

// Check if NUM_DIV is odd
initial begin
    if (NUM_DIV % 2 == 0) begin
        $error("NUM_DIV must be an odd number");
        $finish;
    end
end

localparam HIGH_PERIOD = (NUM_DIV + 1)/2;
localparam LOW_PERIOD = (NUM_DIV - 1)/2;

reg [31:0] counter;
reg [1:0] state;  // 0: counting high, 1: counting low

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        counter <= 0;
        clk_div <= 0;
        state <= 0;
    end
    else begin
        case (state)
            0: begin  // High period counting
                if (counter == HIGH_PERIOD - 1) begin
                    clk_div <= 0;
                    counter <= 0;
                    state <= 1;
                end
                else begin
                    counter <= counter + 1;
                end
            end
            
            1: begin  // Low period counting
                if (counter == LOW_PERIOD - 1) begin
                    clk_div <= 1;
                    counter <= 0;
                    state <= 0;
                end
                else begin
                    counter <= counter + 1;
                end
            end
        endcase
    end
end

endmodule