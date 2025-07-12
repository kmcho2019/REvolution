module TopModule(
    input clk,
    input areset,
    input x,
    output reg z
);

reg [1:0] counter; // Counter to track bits after first '1'
reg first_one_detected; // Flag for first '1' detection

always @(posedge clk or posedge areset) begin
    if (areset) begin
        counter <= 2'b00;
        first_one_detected <= 1'b0;
        z <= 1'b0;
    end else begin
        if (!first_one_detected) begin
            if (x) begin
                first_one_detected <= 1'b1;
                z <= ~x; // Invert the first '1'
            end else begin
                z <= x;
            end
        end else begin
            if (counter == 2'b11) begin // After two bits following the first '1', stop inverting
                z <= x;
            end else begin
                z <= ~x; // Invert bits after the first '1'
                counter <= counter + 1'b1;
            end
        end
    end
end

endmodule