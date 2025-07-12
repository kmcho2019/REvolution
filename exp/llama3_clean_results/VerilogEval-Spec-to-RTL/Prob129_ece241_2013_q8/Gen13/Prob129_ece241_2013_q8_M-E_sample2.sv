module TopModule(
    input  clk,
    input  aresetn,
    input  x,
    output z
);

reg [1:0] counter1; // Counter for consecutive "1"s
reg [1:0] counter0; // Counter for consecutive "0"s after "1"
reg seen_one; // Flag to indicate if a "1" has been seen
reg seen_ten; // Flag to indicate if "10" has been seen

always_ff @(posedge clk or negedge aresetn) begin
    if (!aresetn) begin
        counter1 <= 2'b00;
        counter0 <= 2'b00;
        seen_one <= 1'b0;
        seen_ten <= 1'b0;
    end else begin
        if (x) begin // If input is "1"
            counter1 <= counter1 + 1'b1;
            counter0 <= 2'b00; // Reset counter0
            seen_one <= 1'b1;
            if (seen_ten && counter1 == 2'b01) begin // If "10" seen and now "1"
                // Assert output
            end
        end else begin // If input is "0"
            counter0 <= counter0 + 1'b1;
            counter1 <= 2'b00; // Reset counter1
            if (seen_one && counter0 == 2'b01) begin // If "1" seen and now "0"
                seen_ten <= 1'b1; // Set seen_ten flag
            end else begin
                seen_ten <= 1'b0;
            end
        end
    end
end

assign z = seen_ten && x;

endmodule