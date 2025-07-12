module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire in,
    output reg  disc,
    output reg  flag,
    output reg  err
);

    reg [3:0] count;       // count consecutive ones, saturate at 7
    reg [3:0] prev_count;  // store count from previous cycle

    always @(posedge clk) begin
        if (reset) begin
            count      <= 4'd0;
            prev_count <= 4'd0;
            disc       <= 1'b0;
            flag       <= 1'b0;
            err        <= 1'b0;
        end else begin
            prev_count <= count;

            if (in) begin
                // increment count up to 7
                count <= (count < 4'd7) ? count + 1'b1 : 4'd7;
            end else begin
                count <= 4'd0;
            end

            // Outputs asserted one cycle after condition detected:
            // disc: previous count == 5 and current input == 0 (means count just reset from 5)
            // flag: previous count == 6 and current input == 0
            // err: current count == 7

            disc <= (prev_count == 4'd5) && (in == 1'b0);
            flag <= (prev_count == 4'd6) && (in == 1'b0);
            err  <= (count == 4'd7);
        end
    end

endmodule