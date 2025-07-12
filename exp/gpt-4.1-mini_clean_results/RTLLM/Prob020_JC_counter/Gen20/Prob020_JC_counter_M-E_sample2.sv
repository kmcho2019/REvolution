module JC_counter (
    input  wire       clk,    // Clock signal for synchronous operation
    input  wire       rst_n,  // Asynchronous active-low reset
    output reg [63:0] Q       // 64-bit Johnson counter output
);

    reg direction;            // Direction bit: 1 means insert '1' at MSB, 0 means insert '0'
    reg prev_lsb;             // Store previous LSB to detect toggling

    // On reset, clear Q and set direction to 1
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            Q         <= 64'd0;
            direction <= 1'b1;  // Start by inserting '1' at MSB
            prev_lsb  <= 1'b0;
        end else begin
            // Shift right by 1 and insert direction at MSB
            Q <= {direction, Q[63:1]};
            
            // Detect if LSB toggled compared to previous cycle
            if (Q[0] != prev_lsb)
                direction <= ~direction;  // Toggle direction on LSB change
            
            prev_lsb <= Q[0];
        end
    end

endmodule