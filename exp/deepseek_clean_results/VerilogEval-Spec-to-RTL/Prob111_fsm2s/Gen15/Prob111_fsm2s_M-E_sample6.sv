module TopModule (
    input  clk,
    input  reset,
    input  j,
    input  k,
    output out
);

    // Shift register implementation
    reg [1:0] state_shift = 2'b01;  // Initial state: OFF (01)
    reg j_prev, k_prev;
    
    // Edge detection registers
    always @(posedge clk) begin
        j_prev <= j;
        k_prev <= k;
    end
    
    // Detect rising edges
    wire j_rise = j & ~j_prev;
    wire k_rise = k & ~k_prev;
    
    // State transition logic
    always @(posedge clk) begin
        if (reset) begin
            state_shift <= 2'b01;  // Reset to OFF
        end else begin
            case (state_shift)
                2'b01: if (j_rise) state_shift <= 2'b10;  // OFF→ON
                2'b10: if (k_rise) state_shift <= 2'b01;  // ON→OFF
                default: state_shift <= 2'b01;            // Fail-safe
            endcase
        end
    end
    
    // Output is MSB of shift register
    assign out = state_shift[1];

endmodule