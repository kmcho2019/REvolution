module TopModule (
    input clk,
    input reset,
    input [31:0] in,
    output reg [31:0] out
);

    reg [31:0] prev_in;
    reg [31:0] captured_state;

    always @(posedge clk) begin
        if (reset) begin
            prev_in <= 32'b0;
            captured_state <= 32'b0;
        end
        else begin
            // Store current input for next cycle comparison
            prev_in <= in;
            
            // Detect 1->0 transitions and update captured state
            captured_state <= captured_state | (prev_in & ~in);
        end
    end

    assign out = captured_state;

endmodule