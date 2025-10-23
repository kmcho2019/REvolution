module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire in,
    output reg  disc,
    output reg  flag,
    output reg  err
);

    // 3-bit saturating counter for consecutive ones (0 to 7)
    reg [2:0] count, count_next;

    // Combinational logic: next count and outputs
    reg disc_next, flag_next, err_next;

    always @(*) begin
        // Default outputs deasserted
        disc_next = 1'b0;
        flag_next = 1'b0;
        err_next  = 1'b0;

        // Default: hold current count
        count_next = count;

        if (in) begin
            // Increment saturating count
            count_next = (count < 3'd7) ? (count + 3'd1) : 3'd7;

            // Error if count was >= 6 and input is 1 (now count_next is 7 or 6+)
            if (count >= 3'd6)
                err_next = 1'b1;
        end else begin
            // Input zero resets count
            // Check for bit-stuff discard and flag before reset
            if (count == 3'd5)
                disc_next = 1'b1;   // 0111110 detected
            else if (count == 3'd6)
                flag_next = 1'b1;   // 01111110 detected

            count_next = 3'd0;
        end
    end

    // Sequential logic: update count and outputs synchronously
    always @(posedge clk) begin
        if (reset) begin
            count <= 3'd0;
            disc  <= 1'b0;
            flag  <= 1'b0;
            err   <= 1'b0;
        end else begin
            count <= count_next;
            disc  <= disc_next;
            flag  <= flag_next;
            err   <= err_next;
        end
    end

endmodule