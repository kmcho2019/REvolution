module TopModule(
    input clk,
    input load,
    input [9:0] data,
    output tc
);

    reg [9:0] counter;
    wire [9:0] decremented;
    wire update_enable;
    wire [9:0] next_counter;

    // Ripple-borrow decrementer: decrement counter by 1 if not zero
    // Starting from LSB, flip bits until first '1' is found.
    // This simulates counter - 1 with minimal logic depth.
    function [9:0] decrement_by_one;
        input [9:0] val;
        integer i;
        reg borrow;
        reg [9:0] res;
    begin
        borrow = 1'b1; // initial borrow for subtracting 1
        for (i = 0; i < 10; i = i + 1) begin
            if (borrow == 1'b1) begin
                if (val[i] == 1'b1) begin
                    res[i] = 1'b0;
                    borrow = 1'b0; // borrow cleared
                end else begin
                    res[i] = 1'b1;
                    borrow = 1'b1; // continue borrow
                end
            end else begin
                res[i] = val[i];
            end
        end
        decrement_by_one = res;
    end
    endfunction

    assign tc = (counter == 10'd0);

    // Update enabled if load=1 or (load=0 and counter != 0)
    assign update_enable = load | (~load & (counter != 10'd0));

    wire [9:0] counter_dec = decrement_by_one(counter);

    // Select next counter value based on load or decrement
    assign next_counter = load ? data :
                          (counter != 10'd0 ? counter_dec : 10'd0);

    // Clock gating: update counter only when update_enable is true to reduce toggling
    always @(posedge clk) begin
        if (update_enable)
            counter <= next_counter;
    end

endmodule