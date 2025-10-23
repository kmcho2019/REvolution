module freq_div(
    input CLK_in,  // Input clock signal
    input RST,    // Reset signal
    output reg CLK_50,  // Output clock signal with a frequency of CLK_in divided by 2
    output reg CLK_10,  // Output clock signal with a frequency of CLK_in divided by 10
    output reg CLK_1   // Output clock signal with a frequency of CLK_in divided by 100
);

reg [1:0] state_50;  // State machine for CLK_50
reg [2:0] state_10;  // State machine for CLK_10
reg [5:0] state_100;  // State machine for CLK_1

always @(posedge CLK_in or posedge RST) begin
    if(RST) begin
        // Reset states and outputs
        state_50 <= 0;
        state_10 <= 0;
        state_100 <= 0;
        CLK_50 <= 0;
        CLK_10 <= 0;
        CLK_1 <= 0;
    end else begin
        // Update states
        if(state_50 == 2'b11) begin
            state_50 <= 2'b00;
            CLK_50 <= ~CLK_50;
        end else begin
            state_50 <= state_50 + 1;
        end
        
        if(state_10 == 3'd4) begin
            state_10 <= 3'd0;
            CLK_10 <= ~CLK_10;
        end else begin
            state_10 <= state_10 + 1;
        end
        
        if(state_100 == 6'd49) begin
            state_100 <= 6'd0;
            CLK_1 <= ~CLK_1;
        end else begin
            state_100 <= state_100 + 1;
        end
    end
end

endmodule