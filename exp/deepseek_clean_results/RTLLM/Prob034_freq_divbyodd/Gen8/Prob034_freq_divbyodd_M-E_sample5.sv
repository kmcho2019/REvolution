module freq_divbyodd #(
    parameter NUM_DIV = 5
) (
    input wire clk,
    input wire rst_n,
    output reg clk_div
);

    typedef enum {LOW, MID, HIGH} state_t;
    state_t current_state, next_state;
    
    reg clk_prev;
    wire rising_edge = (clk && !clk_prev);
    wire falling_edge = (!clk && clk_prev);
    
    reg [31:0] edge_count;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            clk_prev <= 0;
        end else begin
            clk_prev <= clk;
        end
    end

    always @(posedge clk or negedge clk or negedge rst_n) begin
        if (!rst_n) begin
            current_state <= LOW;
            edge_count <= 0;
            clk_div <= 0;
        end else begin
            current_state <= next_state;
            
            if (rising_edge || falling_edge) begin
                edge_count <= (edge_count == NUM_DIV - 1) ? 0 : edge_count + 1;
            end
        end
    end

    always @(*) begin
        case (current_state)
            LOW: begin
                clk_div = 0;
                if (edge_count == (NUM_DIV - 1)/2) begin
                    next_state = (rising_edge) ? MID : HIGH;
                end else begin
                    next_state = LOW;
                end
            end
            MID: begin
                clk_div = 1;
                next_state = HIGH;
            end
            HIGH: begin
                clk_div = 1;
                if (edge_count == NUM_DIV - 1) begin
                    next_state = LOW;
                end else begin
                    next_state = HIGH;
                end
            end
            default: begin
                clk_div = 0;
                next_state = LOW;
            end
        endcase
    end

endmodule