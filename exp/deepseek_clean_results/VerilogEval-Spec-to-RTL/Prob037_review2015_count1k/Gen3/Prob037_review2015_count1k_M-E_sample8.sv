module TopModule (
    input clk,
    input reset,
    output [9:0] q
);

reg [4:0] lower_counter;  // Counts 0-31 (5 bits)
reg [4:0] upper_counter;  // Counts 0-31 (5 bits)

wire lower_max = (lower_counter == 5'b11111);  // Lower counter terminal count
wire upper_max = (upper_counter == 5'b00111);  // Upper counter terminal count (7)
wire terminal_count = lower_max & upper_max;

always @(posedge clk) begin
    if (reset) begin
        lower_counter <= 5'b0;
        upper_counter <= 5'b0;
    end
    else begin
        if (terminal_count) begin
            lower_counter <= 5'b0;
            upper_counter <= 5'b0;
        end
        else begin
            // Lower counter always increments
            lower_counter <= lower_counter + 1'b1;
            
            // Upper counter increments only when lower counter rolls over
            if (lower_max) begin
                upper_counter <= upper_counter + 1'b1;
            end
        end
    end
end

// Combine counters to form 10-bit output
assign q = {upper_counter, lower_counter};

endmodule