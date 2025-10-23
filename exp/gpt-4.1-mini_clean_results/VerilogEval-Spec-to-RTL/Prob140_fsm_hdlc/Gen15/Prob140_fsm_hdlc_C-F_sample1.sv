module TopModule(
    input  wire clk,
    input  wire reset,
    input  wire in,
    output reg  disc,
    output reg  flag,
    output reg  err
);

    // State: count of consecutive ones (0 to 7, saturating at 7)
    reg [2:0] count, next_count;
    // Next-cycle outputs
    reg disc_next, flag_next, err_next;

    // Combinational logic for next state and outputs
    always @(*) begin
        // Default assignments
        disc_next = 1'b0;
        flag_next = 1'b0;
        err_next  = 1'b0;
        next_count = count;

        if (in) begin
            // Increment count if less than 7, else saturate
            if (count < 3'd7)
                next_count = count + 3'd1;
            else
                next_count = 3'd7;

            // Error if count already >=6 and input is 1 (7 or more ones)
            if (count >= 3'd6)
                err_next = 1'b1;
        end else begin
            // Input zero resets count
            next_count = 3'd0;

            // Disc: zero after five consecutive ones
            if (count == 3'd5)
                disc_next = 1'b1;
            // Flag: zero after six consecutive ones
            else if (count == 3'd6)
                flag_next = 1'b1;
            // No error on zero input
        end
    end

    // Sequential logic: state update and output register
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