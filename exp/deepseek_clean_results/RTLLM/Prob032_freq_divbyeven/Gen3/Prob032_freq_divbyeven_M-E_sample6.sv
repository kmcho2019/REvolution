module freq_diveven (
    input wire clk,
    input wire rst_n,
    output reg clk_div
);

parameter NUM_DIV = 4; // Must be even and >= 2

// Validate parameter at compile time
initial begin
    if (NUM_DIV < 2 || NUM_DIV[0] != 0) begin
        $error("NUM_DIV must be even and >= 2");
        $finish;
    end
end

localparam HALF_CYCLES = NUM_DIV / 2;
localparam CNT_WIDTH = $clog2(HALF_CYCLES + 1);

typedef enum {LOW, HIGH} state_t;
state_t current_state, next_state;

reg [CNT_WIDTH-1:0] cycle_count;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        current_state <= LOW;
        cycle_count <= 0;
        clk_div <= 0;
    end
    else begin
        current_state <= next_state;
        
        if (cycle_count == HALF_CYCLES - 1) begin
            cycle_count <= 0;
        end
        else begin
            cycle_count <= cycle_count + 1;
        end
    end
end

always @(*) begin
    case (current_state)
        LOW: begin
            clk_div = 0;
            next_state = (cycle_count == HALF_CYCLES - 1) ? HIGH : LOW;
        end
        HIGH: begin
            clk_div = 1;
            next_state = (cycle_count == HALF_CYCLES - 1) ? LOW : HIGH;
        end
        default: begin
            clk_div = 0;
            next_state = LOW;
        end
    endcase
end

endmodule