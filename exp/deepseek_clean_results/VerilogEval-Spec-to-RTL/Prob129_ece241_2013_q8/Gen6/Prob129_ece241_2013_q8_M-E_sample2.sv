module TopModule (
    input clk,
    input aresetn,
    input x,
    output z
);

    reg [1:0] pattern_counter;  // 2-bit counter (values 0-3)

    always @(posedge clk or negedge aresetn) begin
        if (!aresetn) begin
            pattern_counter <= 2'b00;
        end else begin
            case (pattern_counter)
                2'b00: pattern_counter <= x ? 2'b01 : 2'b00;  // Start counting on first '1'
                2'b01: pattern_counter <= x ? 2'b01 : 2'b10;  // Expect '0' next
                2'b10: pattern_counter <= x ? 2'b11 : 2'b00;  // Expect '1' next
                2'b11: pattern_counter <= x ? 2'b01 : 2'b00;  // Reset after detection
            endcase
        end
    end

    // Mealy output: detect when we've seen "101" (counter reaches 3)
    assign z = (pattern_counter == 2'b10) && x;

endmodule