module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire in,
    output reg  disc,
    output reg  flag,
    output reg  err
);

    reg [3:0] count;  // counts consecutive ones, max 7+

    // Update count
    always @(posedge clk) begin
        if (reset) begin
            count <= 4'd0;    // previous input zero
            disc  <= 1'b0;
            flag  <= 1'b0;
            err   <= 1'b0;
        end else begin
            if (in) begin
                if (count < 4'd7)
                    count <= count + 1'b1;
                else
                    count <= 4'd7; // saturate at 7+
            end else begin
                count <= 4'd0;
            end

            // Outputs asserted one cycle *after* the condition:
            // disc: when previous cycle saw zero input after exactly 5 ones (current count == 0, previous count ==5 and current in==0)
            // flag: when zero input after 6 ones (current count == 0, prev count ==6 and current in==0)
            // err : when count saturates at 7 (7 or more consecutive ones)

            // Because outputs are delayed by one cycle, outputs depend on previous count and input.
            // We implement outputs registered at posedge clk as follows:

            // Save previous count and input in internal registers for next cycle output
        end
    end

    // To implement delayed outputs, store previous count and input
    reg [3:0] prev_count;
    reg       prev_in;

    always @(posedge clk) begin
        if (reset) begin
            prev_count <= 4'd0;
            prev_in    <= 1'b0;
        end else begin
            prev_count <= count;
            prev_in    <= in;

            // disc: prev_in==0 & prev_count==5
            // flag: prev_in==0 & prev_count==6
            // err : prev_count == 7 (or more)

            disc <= (~prev_in) & (prev_count == 4'd5);
            flag <= (~prev_in) & (prev_count == 4'd6);
            err  <= (prev_count == 4'd7);
        end
    end

endmodule