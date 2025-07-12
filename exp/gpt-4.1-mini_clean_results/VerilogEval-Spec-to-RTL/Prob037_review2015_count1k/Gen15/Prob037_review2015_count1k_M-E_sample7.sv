module TopModule (
    input clk,
    input reset,
    output reg [9:0] q
);

    // Lower and upper counters, each 5 bits wide
    reg [4:0] count0; // counts 0..31 (32 states)
    reg [4:0] count1; // counts 0..31 (32 states)

    // Terminal count: count1=31, count0=7 corresponds to 999 decimal
    wire terminal_count = (count1 == 5'd31) && (count0 == 5'd7);

    always @(posedge clk) begin
        if (reset) begin
            count0 <= 5'd0;
            count1 <= 5'd0;
            q <= 10'd0;
        end else begin
            if (terminal_count) begin
                // reset both counters to 0
                count0 <= 5'd0;
                count1 <= 5'd0;
                q <= 10'd0;
            end else begin
                if (count0 == 5'd31) begin
                    count0 <= 5'd0;
                    count1 <= count1 + 5'd1;
                end else begin
                    count0 <= count0 + 5'd1;
                end
                q <= {count1, count0};
            end
        end
    end

endmodule