module TopModule(
    input clk,
    input load,
    input [9:0] data,
    output tc
);

    reg [9:0] counter;
    wire count_enable = load | (counter != 10'd0); // Enable counting when loading or counter not zero

    // Simple clock gating: enable register update only when needed
    always @(posedge clk) begin
        if (count_enable) begin
            if (load) begin
                counter <= data;
            end else begin
                counter <= counter - 10'd1;
            end
        end
        // else hold the current counter value (no update, clock gated effectively)
    end

    assign tc = (counter == 10'd0);

endmodule