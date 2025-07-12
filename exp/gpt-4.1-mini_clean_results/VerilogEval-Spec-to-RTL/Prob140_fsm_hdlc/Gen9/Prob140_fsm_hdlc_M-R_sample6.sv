module TopModule(
    input  wire clk,
    input  wire reset,
    input  wire in,
    output wire disc,
    output wire flag,
    output wire err
);

    // count_ones: 3-bit counter for consecutive ones (0 to 6)
    reg [2:0] count_ones;

    // next count logic
    wire [2:0] next_count_ones;
    wire disc_w, flag_w, err_w;

    // Compute next count_ones:
    // If in=1 and count <6 => count+1
    // If in=1 and count=6 => stay at 6 (to detect error if next in=1)
    // If in=0 => reset count_ones to 0
    assign next_count_ones = (in) ?
                              ((count_ones < 3'd6) ? count_ones + 3'd1 : 3'd6)
                              : 3'd0;

    // Detect disc: occurs when previous count_ones=5 and in=0
    assign disc_w = (count_ones == 3'd5) && (in == 1'b0);

    // Detect flag: occurs when previous count_ones=6 and in=0
    assign flag_w = (count_ones == 3'd6) && (in == 1'b0);

    // Detect err: occurs when count_ones ==6 and in=1 (7 or more consecutive ones)
    assign err_w  = (count_ones == 3'd6) && (in == 1'b1);

    // Sequential logic: update count_ones synchronously with reset
    always @(posedge clk) begin
        if (reset)
            count_ones <= 3'd0;
        else
            count_ones <= next_count_ones;
    end

    // Moore outputs: asserted for one full cycle starting on clock after event
    reg disc_r, flag_r, err_r;
    always @(posedge clk) begin
        if (reset) begin
            disc_r <= 1'b0;
            flag_r <= 1'b0;
            err_r  <= 1'b0;
        end else begin
            disc_r <= disc_w;
            flag_r <= flag_w;
            err_r  <= err_w;
        end
    end

    assign disc = disc_r;
    assign flag = flag_r;
    assign err  = err_r;

endmodule