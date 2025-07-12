module freq_divbyodd #(
    parameter NUM_DIV = 5  // Must be odd number
) (
    input wire clk,
    input wire rst_n,
    output reg clk_div
);

// Verify parameter is odd
initial begin
    if (NUM_DIV % 2 == 0) begin
        $error("NUM_DIV must be an odd number");
        $finish;
    end
end

// State encoding
localparam S_HIGH  = 1'b0;
localparam S_LOW   = 1'b1;
reg state, next_state;

// Counter and control signals
reg [31:0] counter;
wire high_done = (counter == (NUM_DIV - 1)/2);
wire low_done  = (counter == NUM_DIV - 1);

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= S_HIGH;
        counter <= 0;
        clk_div <= 0;
    end
    else begin
        state <= next_state;
        
        case (state)
            S_HIGH: begin
                clk_div <= 1;
                if (high_done) begin
                    counter <= 0;
                end
                else begin
                    counter <= counter + 1;
                end
            end
            
            S_LOW: begin
                clk_div <= 0;
                if (low_done) begin
                    counter <= 0;
                end
                else begin
                    counter <= counter + 1;
                end
            end
        endcase
    end
end

// Next state logic
always @(*) begin
    case (state)
        S_HIGH: next_state = high_done ? S_LOW : S_HIGH;
        S_LOW:  next_state = low_done  ? S_HIGH : S_LOW;
        default: next_state = S_HIGH;
    endcase
end

endmodule