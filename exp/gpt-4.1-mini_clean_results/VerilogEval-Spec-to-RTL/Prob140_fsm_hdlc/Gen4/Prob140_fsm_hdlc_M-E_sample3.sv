module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire in,
    output reg  disc,
    output reg  flag,
    output reg  err
);

    // State: count of consecutive ones, saturates at 7
    reg [2:0] count, count_next;

    // Internal signals for outputs, registered to assert outputs one cycle after detection
    reg disc_int, flag_int, err_int;

    // Next-state logic: increment count on '1' saturating at 7, else reset to 0 on '0'
    always @(*) begin
        if (in)
            count_next = (count < 7) ? count + 1'b1 : 3'd7; // saturate at 7
        else
            count_next = 3'd0;
    end

    // Output detection combinational logic based on current count and input:
    // Conditions detected *this* cycle that cause outputs to assert *next* cycle
    wire disc_detect = (count == 3'd5) && (in == 1'b0);   // exactly 5 ones then 0
    wire flag_detect = (count == 3'd6) && (in == 1'b0);   // exactly 6 ones then 0
    wire err_detect  = (count == 3'd7) && (in == 1'b1);   // 7 or more consecutive ones

    // Sequential logic: update count and register outputs
    always @(posedge clk) begin
        if (reset) begin
            count   <= 3'd0;
            disc_int <= 1'b0;
            flag_int <= 1'b0;
            err_int  <= 1'b0;
            disc     <= 1'b0;
            flag     <= 1'b0;
            err      <= 1'b0;
        end else begin
            count <= count_next;

            // Register internal detection signals for output assertion one cycle after detection
            disc_int <= disc_detect;
            flag_int <= flag_detect;

            // err_int is set on detecting 7 consecutive ones, and stays set while count==7
            if (err_detect)
                err_int <= 1'b1;
            else if (count_next != 3'd7)
                err_int <= 1'b0;

            // Outputs are registered versions of internal signals (Moore outputs)
            disc <= disc_int;
            flag <= flag_int;
            err  <= err_int;
        end
    end

endmodule