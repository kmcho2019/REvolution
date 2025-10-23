module freq_divbyfrac (
    input wire clk,
    input wire rst_n,
    output wire clk_div
);

// State machine states
typedef enum logic [1:0] {
    STATE_4CLK_HIGH,
    STATE_4CLK_LOW,
    STATE_3CLK_HIGH,
    STATE_3CLK_LOW
} state_t;

// Internal signals
reg [1:0] counter;
state_t current_state, next_state;
reg clk_4x, clk_3x;
reg clk_out;

// State machine and counters
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        current_state <= STATE_4CLK_HIGH;
        counter <= 2'b0;
        clk_4x <= 1'b1;
        clk_3x <= 1'b1;
    end else begin
        current_state <= next_state;
        
        // 4x divider counter (counts 0-3)
        if (current_state inside {STATE_4CLK_HIGH, STATE_4CLK_LOW}) begin
            counter <= (counter == 3) ? 2'b0 : counter + 1;
        end 
        // 3x divider counter (counts 0-2)
        else begin
            counter <= (counter == 2) ? 2'b0 : counter + 1;
        end
        
        // Generate the 4x divided clock
        case (current_state)
            STATE_4CLK_HIGH: clk_4x <= (counter < 2) ? 1'b1 : 1'b0;
            STATE_4CLK_LOW:  clk_4x <= (counter < 2) ? 1'b0 : 1'b1;
            default:         clk_4x <= 1'b0;
        endcase
        
        // Generate the 3x divided clock
        case (current_state)
            STATE_3CLK_HIGH: clk_3x <= (counter < 1) ? 1'b1 : 1'b0;
            STATE_3CLK_LOW:  clk_3x <= (counter < 1) ? 1'b0 : 1'b1;
            default:         clk_3x <= 1'b0;
        endcase
    end
end

// State transition logic
always_comb begin
    case (current_state)
        STATE_4CLK_HIGH: next_state = (counter == 3) ? STATE_4CLK_LOW : STATE_4CLK_HIGH;
        STATE_4CLK_LOW:  next_state = (counter == 3) ? STATE_3CLK_HIGH : STATE_4CLK_LOW;
        STATE_3CLK_HIGH: next_state = (counter == 2) ? STATE_3CLK_LOW : STATE_3CLK_HIGH;
        STATE_3CLK_LOW:  next_state = (counter == 2) ? STATE_4CLK_HIGH : STATE_3CLK_LOW;
        default:         next_state = STATE_4CLK_HIGH;
    endcase
end

// Output selection mux
assign clk_div = (current_state inside {STATE_4CLK_HIGH, STATE_4CLK_LOW}) ? clk_4x : clk_3x;

endmodule