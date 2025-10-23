module TopModule (
    input clk,
    input reset,
    output reg [9:0] q
);

reg [6:0] units_counter;  // Counts 0-99 (7 bits)
reg [2:0] hundreds_counter; // Counts 0-9 (3 bits)

wire units_max = (units_counter == 7'd99);
wire hundreds_max = (hundreds_counter == 3'd9);
wire terminal_count = units_max & hundreds_max;

always @(posedge clk) begin
    if (reset) begin
        units_counter <= 7'b0;
        hundreds_counter <= 3'b0;
    end
    else begin
        if (terminal_count) begin
            units_counter <= 7'b0;
            hundreds_counter <= 3'b0;
        end
        else begin
            if (units_max) begin
                units_counter <= 7'b0;
                hundreds_counter <= hundreds_counter + 1'b1;
            end
            else begin
                units_counter <= units_counter + 1'b1;
            end
        end
    end
end

// Combine counters to form final output (hundreds*100 + units)
always @(*) begin
    q = {hundreds_counter, 7'b0} + {4'b0, hundreds_counter, 5'b0} + {3'b0, units_counter};
end

endmodule