module TopModule (
    input clk,
    input reset,
    input data,
    output reg start_shifting
);

    reg [2:0] shift_reg;  // Stores last 3 bits
    reg expecting_last;   // State bit: expecting the final '1'

    always @(posedge clk) begin
        if (reset) begin
            shift_reg <= 3'b0;
            expecting_last <= 1'b0;
            start_shifting <= 1'b0;
        end else if (!start_shifting) begin
            // Shift in new data
            shift_reg <= {shift_reg[1:0], data};
            
            // Check if we should enter "expecting last 1" state
            if (shift_reg == 3'b110) begin
                expecting_last <= 1'b1;
            end
            
            // Check if we're in "expecting last 1" state and get the final '1'
            if (expecting_last && data) begin
                start_shifting <= 1'b1;
                expecting_last <= 1'b0;
            end else if (expecting_last && !data) begin
                expecting_last <= 1'b0;  // Reset if we don't get the final '1'
            end
        end
    end

endmodule