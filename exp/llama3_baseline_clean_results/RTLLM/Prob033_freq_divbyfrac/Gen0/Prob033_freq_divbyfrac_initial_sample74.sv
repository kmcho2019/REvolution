module freq_divbyfrac (
    input  clk,      // Input clock signal
    input  rst_n,    // Active low reset signal
    output clk_div   // Fractionally divided clock output
);

// Define parameters for the fractional frequency division
parameter MUL2_DIV_CLK = 7; // Total clock cycles for fractional division

// Define the states for the state machine
reg [2:0] state; // State register
reg [2:0] next_state; // Next state register

// Define the signals for the intermediate divided clocks
reg clk_div_1; // First intermediate divided clock
reg clk_div_2; // Second intermediate divided clock
reg clk_div_1_delayed; // Delayed version of the first intermediate divided clock
reg clk_div_2_advanced; // Advanced version of the second intermediate divided clock

// Define the counter for the fractional frequency division
reg [2:0] counter; // Counter register
reg [2:0] next_counter; // Next counter value

// Define the signal for the final fractional divided clock output
reg clk_div_out; // Final fractional divided clock output

// State machine and counter logic
always @(*) begin
    next_state = state;
    next_counter = counter;
    
    case (state)
        3'b000: begin // State 0: Initialize counter and state
            next_counter = 3'b000;
            next_state = 3'b001;
        end
        3'b001: begin // State 1: Count up to 3
            if (counter == 3'b011) begin
                next_counter = 3'b000;
                next_state = 3'b010;
            end else begin
                next_counter = counter + 1'b1;
                next_state = 3'b001;
            end
        end
        3'b010: begin // State 2: Count up to 4
            if (counter == 3'b100) begin
                next_counter = 3'b000;
                next_state = 3'b001;
            end else begin
                next_counter = counter + 1'b1;
                next_state = 3'b010;
            end
        end
        default: begin
            next_state = 3'b000;
            next_counter = 3'b000;
        end
    endcase
end

// Clock divider logic
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin // Reset
        state <= 3'b000;
        counter <= 3'b000;
        clk_div_1 <= 1'b0;
        clk_div_2 <= 1'b0;
        clk_div_1_delayed <= 1'b0;
        clk_div_2_advanced <= 1'b0;
        clk_div_out <= 1'b0;
    end else begin
        state <= next_state;
        counter <= next_counter;
        
        // Generate intermediate divided clocks
        if (state == 3'b001 && counter == 3'b011) begin
            clk_div_1 <= 1'b1;
        end else if (state == 3'b001 && counter == 3'b000) begin
            clk_div_1 <= 1'b0;
        end
        
        if (state == 3'b010 && counter == 3'b100) begin
            clk_div_2 <= 1'b1;
        end else if (state == 3'b010 && counter == 3'b000) begin
            clk_div_2 <= 1'b0;
        end
        
        // Generate phase-shifted versions of the divided clocks
        if (clk_div_1) begin
            clk_div_1_delayed <= 1'b1;
        end else begin
            clk_div_1_delayed <= 1'b0;
        end
        
        if (clk_div_2) begin
            clk_div_2_advanced <= 1'b1;
        end else begin
            clk_div_2_advanced <= 1'b0;
        end
        
        // Generate final fractional divided clock output
        if (clk_div_1_delayed || clk_div_2_advanced) begin
            clk_div_out <= 1'b1;
        end else begin
            clk_div_out <= 1'b0;
        end
    end
end

// Assign output
assign clk_div = clk_div_out;

endmodule