module freq_divbyodd #(
    parameter NUM_DIV = 5
) (
    input wire clk,
    input wire rst_n,
    output reg clk_div
);

    typedef enum {IDLE, HIGH, LOW} state_t;
    state_t state, next_state;
    
    reg clk_prev;
    wire rising_edge = (clk && !clk_prev);
    wire falling_edge = (!clk && clk_prev);
    
    reg [31:0] edge_count;
    localparam EDGE_TARGET = (NUM_DIV - 1);

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            clk_prev <= 0;
        end else begin
            clk_prev <= clk;
        end
    end

    always @(*) begin
        case (state)
            IDLE: next_state = (edge_count == EDGE_TARGET) ? IDLE : HIGH;
            HIGH: next_state = (edge_count >= (EDGE_TARGET-1)/2) ? LOW : HIGH;
            LOW: next_state = (edge_count >= EDGE_TARGET) ? IDLE : HIGH;
            default: next_state = IDLE;
        endcase
    end

    always @(posedge clk or negedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
            edge_count <= 0;
            clk_div <= 0;
        end else begin
            state <= next_state;
            
            if (rising_edge || falling_edge) begin
                edge_count <= (edge_count >= EDGE_TARGET) ? 0 : edge_count + 1;
            end
            
            case (next_state)
                HIGH: clk_div <= 1;
                LOW: clk_div <= 0;
                IDLE: begin
                    clk_div <= 0;
                    edge_count <= 0;
                end
            endcase
        end
    end

endmodule