module TopModule(
    input clk,
    input load,
    input [9:0] data,
    output tc
);

    reg [9:0] counter;
    wire [9:0] dec_counter;
    wire load_en;

    // Calculate counter minus one, saturating at zero
    assign dec_counter = (counter != 0) ? (counter - 1) : 10'd0;

    // Load enable: update counter only if loading or counting down (counter not zero)
    assign load_en = load | (counter != 0);

    always @(posedge clk) begin
        if (load_en) begin
            if (load)
                counter <= data;
            else
                counter <= dec_counter;
        end
        // else hold the current counter value, preventing toggling
    end

    assign tc = (counter == 0);

endmodule