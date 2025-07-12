module freq_diveven (
    input wire clk,
    input wire rst_n,
    output reg clk_div
);

parameter NUM_DIV = 4; // Must be even number (2, 4, 6, ...)

typedef enum {LOW, HIGH} state_t;
state_t current_state, next_state;
reg [3:0] cycle_count; // Tracks cycles in current state

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        current_state <= LOW;
        cycle_count <= 0;
        clk_div <= 0;
    end else begin
        current_state <= next_state;
        if (cycle_count == (NUM_DIV/2 - 1))
            cycle_count <= 0;
        else
            cycle_count <= cycle_count + 1;
        
        clk_div <= (current_state == HIGH);
    end
end

always @(*) begin
    case (current_state)
        LOW: next_state = (cycle_count == (NUM_DIV/2 - 1)) ? HIGH : LOW;
        HIGH: next_state = (cycle_count == (NUM_DIV/2 - 1)) ? LOW : HIGH;
        default: next_state = LOW;
    endcase
end

endmodule