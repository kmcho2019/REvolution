module freq_div(
    input CLK_in,  // Input clock signal
    input RST,    // Reset signal
    output reg CLK_50,  // Output clock signal with a frequency of CLK_in divided by 2
    output reg CLK_10,  // Output clock signal with a frequency of CLK_in divided by 10
    output reg CLK_1   // Output clock signal with a frequency of CLK_in divided by 100
);

reg [6:0] counter;  // Single, programmable counter
reg [1:0] state;   // State machine to manage division process
reg [6:0] div_factor;  // Division factor for current state

always @(posedge CLK_in or posedge RST) begin
    if(RST) begin
        // Reset counter, state, and output clocks
        counter <= 0;
        state <= 0;
        CLK_50 <= 0;
        CLK_10 <= 0;
        CLK_1 <= 0;
    end else begin
        case(state)
            2'b00: begin  // State 0: Divide by 2 for CLK_50
                div_factor <= 1;  // Division factor for CLK_50
                if(counter == div_factor) begin
                    // Toggle CLK_50 and reset counter
                    CLK_50 <= ~CLK_50;
                    counter <= 0;
                end else begin
                    counter <= counter + 1;
                end
            end
            2'b01: begin  // State 1: Divide by 10 for CLK_10
                div_factor <= 4;  // Division factor for CLK_10
                if(counter == div_factor) begin
                    // Toggle CLK_10 and reset counter
                    CLK_10 <= ~CLK_10;
                    counter <= 0;
                    state <= 2'b10;  // Move to next state
                end else begin
                    counter <= counter + 1;
                end
            end
            2'b10: begin  // State 2: Divide by 100 for CLK_1
                div_factor <= 49;  // Division factor for CLK_1
                if(counter == div_factor) begin
                    // Toggle CLK_1 and reset counter
                    CLK_1 <= ~CLK_1;
                    counter <= 0;
                    state <= 2'b00;  // Move to initial state
                end else begin
                    counter <= counter + 1;
                end
            end
            default: begin
                // Invalid state, reset to initial state
                state <= 2'b00;
            end
        endcase
    end
end

endmodule