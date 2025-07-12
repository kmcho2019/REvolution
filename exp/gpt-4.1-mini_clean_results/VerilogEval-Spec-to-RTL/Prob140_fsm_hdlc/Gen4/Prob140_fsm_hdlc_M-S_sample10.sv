module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire in,
    output reg  disc,
    output reg  flag,
    output reg  err
);

    reg [3:0] count, prev_count; // count consecutive ones, max 7 for error

    always @(posedge clk) begin
        if (reset) begin
            count <= 4'd0;
            prev_count <= 4'd0;
            disc <= 1'b0;
            flag <= 1'b0;
            err <= 1'b0;
        end else begin
            prev_count <= count;

            // Update count of consecutive ones
            if (in)
                count <= (count < 4'd7) ? count + 1'b1 : 4'd7;
            else
                count <= 4'd0;

            // Outputs asserted one cycle after detecting zero following count=5 or 6
            disc <= (prev_count == 4'd5) && (in == 1'b0);
            flag <= (prev_count == 4'd6) && (in == 1'b0);

            // Error if count >=7
            err <= (count == 4'd7);
        end
    end

endmodule