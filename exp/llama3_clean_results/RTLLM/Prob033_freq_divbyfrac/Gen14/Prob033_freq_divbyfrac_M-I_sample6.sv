module freq_divbyfrac (
    input  clk,        // Input clock signal
    input  rst_n,       // Active low reset signal
    output reg clk_div  // Fractionally divided clock output
);

// Parameters for fractional frequency division
parameter MUL2_DIV_CLK = 7;  // Total clock cycles for 3.5x division

// Internal signals
reg [2:0] cnt;  // Counter to track clock cycles
reg [1:0] state;  // State for the FSM
reg prev_clk;   // Previous clock value for edge detection

// Sequential logic for counter and state machine
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cnt <= 3'b000;
        state <= 2'b00;
        prev_clk <= 1'b0;
        clk_div <= 1'b0;
    end else begin
        prev_clk <= clk;
        
        // Update counter and state
        if (cnt == MUL2_DIV_CLK - 1) begin
            cnt <= 3'b000;
            state <= 2'b00;
        end else begin
            cnt <= cnt + 1'b1;
            case (state)
                2'b00: if (cnt < 4) state <= 2'b01; else state <= 2'b10;
                2'b01: state <= 2'b01;
                2'b10: state <= 2'b10;
            endcase
        end
        
        // Update clk_div based on state
        case (state)
            2'b00: clk_div <= 1'b0;
            2'b01: clk_div <= 1'b1;
            2'b10: clk_div <= 1'b1;
        endcase
    end
end

endmodule