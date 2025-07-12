module TopModule(
    input clk,
    input load,
    input [9:0] data,
    output tc
);

    reg [9:0] counter;
    wire is_zero;

    // Zero detection by OR-reduction followed by inversion (faster and smaller than equality comparator)
    assign is_zero = ~( |counter );
    assign tc = is_zero;

    always @(posedge clk) begin
        if (load) begin
            counter <= data;
        end else if (!is_zero) begin
            counter <= counter - 1;
        end else begin
            counter <= counter; // Remain at zero to avoid toggling
        end
    end

endmodule