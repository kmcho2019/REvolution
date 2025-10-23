module TopModule (
    input clk,
    input reset,
    output shift_ena
);

    reg [3:0] shift_pattern;
    
    assign shift_ena = shift_pattern[3];  // MSB is the output
    
    always @(posedge clk) begin
        if (reset) begin
            shift_pattern <= 4'b1111;  // Load enable pattern
        end else begin
            shift_pattern <= {shift_pattern[2:0], 1'b0};  // Right shift with 0 input
        end
    end

endmodule