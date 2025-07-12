module TopModule(
    input        clk,
    input        load,
    input  [9:0] data,
    output       tc
);
    reg [9:1] counter_upper;   // Bits 9 down to 1 stored in a register vector
    wire       counter_lsb_q;  // Output of the single instantiated D flip-flop (bit 0)
    wire       next_lsb;
    reg  [9:1] next_counter_upper;
    wire [9:0] next_counter;

    // Instantiate the single D flip-flop for bit 0
    DFF dff0 (
        .clk(clk),
        .d(next_counter[0]),
        .q(counter_lsb_q)
    );

    // Current full counter value (combining upper bits and LSB from DFF output)
    wire [9:0] counter = {counter_upper, counter_lsb_q};

    // Compute next_counter based on load and decrement logic
    // If load==1, load data
    // else if counter != 0, decrement by 1
    // else hold zero
    assign next_counter = load ? data :
                          (counter != 0 ? (counter - 10'd1) : 10'd0);

    // Split next_counter into upper bits and LSB
    always @(posedge clk) begin
        if (load) begin
            counter_upper <= data[9:1];
        end else if (counter != 0) begin
            counter_upper <= next_counter[9:1];
        end else begin
            // Hold zero
            counter_upper <= counter_upper;
        end
    end

    // Assign the LSB input of the D flip-flop (already assigned in next_counter[0])

    // terminal count output: asserted when counter == 0
    assign tc = (counter == 10'd0);

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