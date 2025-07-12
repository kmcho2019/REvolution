module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire in,
    output reg  disc,
    output reg  flag,
    output reg  err
);

    reg [2:0] counter; // counts consecutive ones saturating at 7

    always @(posedge clk) begin
        if (reset) begin
            counter <= 3'd0;
            disc    <= 1'b0;
            flag    <= 1'b0;
            err     <= 1'b0;
        end else begin
            // Update counter: count consecutive ones saturating at 7
            if (in) begin
                if (counter < 3'd7)
                    counter <= counter + 3'd1;
                else
                    counter <= 3'd7;
            end else begin
                counter <= 3'd0;
            end

            // Generate Moore outputs with one cycle delay (based on previous cycle's counter and current input)
            disc <= (counter == 3'd5) && (in == 1'b0); // disc after 5 ones and zero detected (0111110)
            flag <= (counter == 3'd6) && (in == 1'b0); // flag after 6 ones and zero detected (01111110)
            err  <= (in && ((counter == 3'd6) || (counter == 3'd7))); // error if 7 or more consecutive ones (7+)
        end
    end

endmodule