module freq_div(
    input CLK_in,  // Input clock signal
    input RST,    // Reset signal
    output reg CLK_50,  // Output clock signal with a frequency of CLK_in divided by 2
    output reg CLK_10,  // Output clock signal with a frequency of CLK_in divided by 10
    output reg CLK_1   // Output clock signal with a frequency of CLK_in divided by 100
);

reg [1:0] state;  // State machine state
reg [5:0] cnt_10;  // Counter for CLK_10
reg [6:0] cnt_100;  // Counter for CLK_1

// State machine and counter logic
always @(posedge CLK_in or posedge RST) begin
    if(RST) begin
        // Reset state and counters
        state <= 0;
        cnt_10 <= 0;
        cnt_100 <= 0;
        CLK_50 <= 0;
        CLK_10 <= 0;
        CLK_1 <= 0;
    end else begin
        case(state)
            0: begin  // INIT state
                state <= 1;
            end
            1: begin  // COUNT state
                // Increment counters
                cnt_10 <= cnt_10 + 1;
                cnt_100 <= cnt_100 + 1;

                // Check counter values and toggle output clocks
                if(cnt_10 == 9) begin
                    cnt_10 <= 0;
                    CLK_10 <= ~CLK_10;
                end
                if(cnt_100 == 99) begin
                    cnt_100 <= 0;
                    CLK_1 <= ~CLK_1;
                end

                // Toggle CLK_50
                CLK_50 <= ~CLK_50;

                state <= 1;
            end
            default: begin
                state <= 0;
            end
        endcase
    end
end

endmodule