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

localparam HIGH_CYCLES = (NUM_DIV + 1) / 2;
localparam LOW_CYCLES = (NUM_DIV - 1) / 2;
reg [31:0] edge_counter;
reg state;

always @(posedge clk or negedge clk or negedge rst_n) begin
    if (!rst_n) begin
        edge_counter <= 0;
        clk_div <= 0;
        state <= 0;
    end
    else begin
        edge_counter <= edge_counter + 1;
        
        case (state)
            0: begin  // Low state
                if (edge_counter >= LOW_CYCLES - 1) begin
                    clk_div <= 1;
                    state <= 1;
                    edge_counter <= 0;
                end
            end
            1: begin  // High state
                if (edge_counter >= HIGH_CYCLES - 1) begin
                    clk_div <= 0;
                    state <= 0;
                    edge_counter <= 0;
                end
            end
        endcase
    end
end

endmodule