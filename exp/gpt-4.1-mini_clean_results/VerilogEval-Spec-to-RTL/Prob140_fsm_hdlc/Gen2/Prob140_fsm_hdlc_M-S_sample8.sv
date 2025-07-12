module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire in,
    output reg  disc,
    output reg  flag,
    output reg  err
);

    reg [2:0] count, next_count;
    reg disc_next, flag_next, err_next;

    always @(*) begin
        disc_next = 1'b0;
        flag_next = 1'b0;
        err_next  = 1'b0;

        if (in) begin
            if (count < 7)
                next_count = count + 1;
            else
                next_count = 7; // stay in error count

            // Error if count ==7 and input still 1
            if (count == 7)
                err_next = 1'b1;
        end else begin
            // input zero resets count
            next_count = 0;
            // disc if previous count was 5
            if (count == 5)
                disc_next = 1'b1;
            // flag if previous count was 6
            else if (count == 6)
                flag_next = 1'b1;
        end
    end

    always @(posedge clk) begin
        if (reset) begin
            count <= 3'd0;
            disc  <= 1'b0;
            flag  <= 1'b0;
            err   <= 1'b0;
        end else begin
            count <= next_count;
            disc  <= disc_next;
            flag  <= flag_next;
            err   <= err_next;
        end
    end

endmodule