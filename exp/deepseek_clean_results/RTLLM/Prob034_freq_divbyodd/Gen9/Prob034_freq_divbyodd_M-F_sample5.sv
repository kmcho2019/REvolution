module freq_divbyodd #(
    parameter NUM_DIV = 5
) (
    input wire clk,
    input wire rst_n,
    output reg clk_div
);

    typedef enum {HIGH, LOW} state_t;
    state_t state, next_state;
    
    reg clk_prev;
    wire rising_edge;
    wire falling_edge;
    
    reg [31:0] edge_count;
    localparam EDGE_TARGET = (NUM_DIV - 1);
    localparam HALF_CYCLE = (NUM_DIV - 1)/2;

    // Edge detection
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            clk_prev <= 0;
        end else begin
            clk_prev <= clk;
        end
    end
    
    assign rising_edge = (clk && !clk_prev);
    assign falling_edge = (!clk && clk_prev);

    // Next state logic
    always @(*) begin
        case (state)
            HIGH: next_state = (edge_count >= HALF_CYCLE) ? LOW : HIGH;
            LOW: next_state = (edge_count >= EDGE_TARGET) ? HIGH : LOW;
            default: next_state = HIGH;
        endcase
    end

    // State machine and edge counting
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= HIGH;
            edge_count <= 0;
            clk_div <= 0;
        end else begin
            // Count both edges
            if (rising_edge || falling_edge) begin
                edge_count <= (edge_count >= EDGE_TARGET) ? 0 : edge_count + 1;
            end
            
            state <= next_state;
            
            // Output generation
            case (next_state)
                HIGH: clk_div <= 1;
                LOW: clk_div <= 0;
            endcase
        end
    end

endmodule