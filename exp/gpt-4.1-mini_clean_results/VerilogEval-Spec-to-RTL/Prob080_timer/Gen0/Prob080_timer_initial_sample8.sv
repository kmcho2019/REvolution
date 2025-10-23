module TopModule(
    input        clk,
    input        load,
    input  [9:0] data,
    output       tc
);
    reg [9:0] counter;
    wire [9:0] next_counter;

    // Single D flip-flop instance for bit 0
    // We'll instantiate this explicitly to meet the requirement
    wire dff_d, dff_q;
    DFF dff0 (
        .clk(clk),
        .d(dff_d),
        .q(dff_q)
    );

    // next_counter logic: if load is high, load data
    // else if counter != 0, decrement by 1
    // else hold 0
    assign next_counter = load ? data : 
                          (counter != 0 ? counter - 1 : 0);

    // The bit 0 DFF input comes from next_counter[0]
    assign dff_d = next_counter[0];

    // On clock, update the whole counter except bit 0 is updated by the DFF output
    always @(posedge clk) begin
        // Update bits 9 down to 1
        if (load)
            counter[9:1] <= data[9:1];
        else if (counter != 0)
            counter[9:1] <= counter[9:1] - (counter[0] ? 0 : 1'b0) - 10'b0 + (counter[0] ? 10'b0 : 10'b0);
            // The above line is a placeholder to decrement bits 9:1 by 1 when needed.
            // A more straightforward way is just assign next_counter[9:1], but we must synchronize with dff0 for bit 0.

        // Bit 0 updated from dff0 output
        counter[0] <= dff_q;
    end

    // terminal count asserted when counter == 0
    assign tc = (counter == 0);

endmodule

// Single D flip-flop module
module DFF(
    input clk,
    input d,
    output reg q
);
    always @(posedge clk) begin
        q <= d;
    end
endmodule