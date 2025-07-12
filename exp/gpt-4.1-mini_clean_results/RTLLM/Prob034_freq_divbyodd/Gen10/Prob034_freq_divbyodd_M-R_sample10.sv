module freq_divbyodd #(
    parameter integer NUM_DIV = 5  // Must be odd
)(
    input  wire clk,
    input  wire rst_n,     // Active low reset
    output wire clk_div
);

    // Compile-time check for odd NUM_DIV
    initial begin
        if (NUM_DIV % 2 == 0) begin
            $error("NUM_DIV parameter must be an odd number.");
        end
    end

    localparam integer HALF_DIV = NUM_DIV / 2;  // floor division

    // Width for counter (minimum bits to count up to NUM_DIV-1)
    localparam CNT_WIDTH = $clog2(NUM_DIV);

    reg [CNT_WIDTH-1:0] cnt;

    // Pulse signals for set and clear events of clk_div1 and clk_div2
    wire pulse_set;
    wire pulse_clear;

    // Generate pulses at counter == 0 and counter == HALF_DIV
    assign pulse_set   = (cnt == 0);
    assign pulse_clear = (cnt == HALF_DIV);

    // Two registers for clk_div1 and clk_div2, toggled on different pulses
    reg clk_div1;
    reg clk_div2;

    // Single always block on posedge clk and async reset
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt      <= 0;
            clk_div1 <= 0;
            clk_div2 <= 0;
        end else begin
            // Counter increments modulo NUM_DIV
            if (cnt == NUM_DIV - 1)
                cnt <= 0;
            else
                cnt <= cnt + 1;

            // Toggle clk_div1 on pulse_set and pulse_clear alternately
            // Use a state to remember last toggle to produce half period pulses
            // Here, toggle clk_div1 on pulse_set and clear on pulse_clear
            if (pulse_set)
                clk_div1 <= 1'b1;
            else if (pulse_clear)
                clk_div1 <= 1'b0;

            // clk_div2 is phase shifted by one clock cycle
            // We create delayed pulses by offsetting pulse_set and pulse_clear by one count
            // To do so, check if counter == (NUM_DIV/2 + 1) mod NUM_DIV and (NUM_DIV + 1) mod NUM_DIV

            // Calculate pulse_set_2 and pulse_clear_2 using combinational logic
            // Because we are in synchronous block, we need combinational signals

            // We'll compute delayed pulses using combinational functions below
            // For code clarity, compute delayed pulses outside always block as wires

            // So just toggle clk_div2 on pulses generated outside
        end
    end

    // Generate delayed pulses for clk_div2: shifted by 1 count modulo NUM_DIV
    wire [CNT_WIDTH-1:0] cnt_delayed = (cnt == 0) ? NUM_DIV - 1 : cnt - 1;
    wire pulse_set_2   = (cnt_delayed == 0);
    wire pulse_clear_2 = (cnt_delayed == HALF_DIV);

    // Because clk_div2 is updated only on posedge clk, register clk_div2 similarly
    // We use another always block triggered on posedge clk and rst_n to update clk_div2 synchronously with clk_div1
    // But since one always block is preferred, merge logic here with clk_div2

    // Re-implement the always block with clk_div2 included:

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt      <= 0;
            clk_div1 <= 0;
            clk_div2 <= 0;
        end else begin
            if (cnt == NUM_DIV - 1)
                cnt <= 0;
            else
                cnt <= cnt + 1;

            // clk_div1: set at pulse_set, clear at pulse_clear
            if (pulse_set)
                clk_div1 <= 1'b1;
            else if (pulse_clear)
                clk_div1 <= 1'b0;

            // clk_div2: set at pulse_set_2, clear at pulse_clear_2
            if (pulse_set_2)
                clk_div2 <= 1'b1;
            else if (pulse_clear_2)
                clk_div2 <= 1'b0;
        end
    end

    // Final output
    assign clk_div = clk_div1 | clk_div2;

endmodule