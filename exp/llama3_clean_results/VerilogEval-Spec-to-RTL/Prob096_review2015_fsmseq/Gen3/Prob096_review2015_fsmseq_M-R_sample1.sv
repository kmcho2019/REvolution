module TopModule(
    input  clk,
    input  reset,
    input  data,
    output reg start_shifting
);

reg [2:0] state; // Using a 3-bit reg for the state machine

// Next state logic
always @(posedge clk) begin
    if (reset) begin
        state <= 3'b000; // Reset to S0
        start_shifting <= 0;
    end else begin
        case (state)
            3'b000: state <= data? 3'b001 : 3'b000; // S0
            3'b001: state <= data? 3'b010 : 3'b000; // S1
            3'b010: state <= data? 3'b010 : 3'b011; // S2
            3'b011: state <= data? 3'b100 : 3'b000; // S3
            3'b100: state <= 3'b100; // S4, stay here once reached
            default: state <= 3'b000; // Default to S0
        endcase
        
        // Set start_shifting based on the current state
        if (state == 3'b100) begin
            start_shifting <= 1;
        end else if (reset) begin
            start_shifting <= 0;
        end
    end
end

endmodule