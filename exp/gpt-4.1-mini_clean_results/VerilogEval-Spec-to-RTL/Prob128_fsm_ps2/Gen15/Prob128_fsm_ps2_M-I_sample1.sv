module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output reg done
);

    reg [1:0] count;
    wire start_byte = in[3];
    wire count_en;

    // Enable count when inside a message (count!=0) or when start byte detected (start message)
    assign count_en = (count != 2'd0) | start_byte;

    always @(posedge clk) begin
        if (reset) begin
            count <= 2'd0;
            done <= 1'b0;
        end else begin
            done <= 1'b0;  // default

            if (count_en) begin
                if (count == 2'd2) begin
                    done <= 1'b1;
                    count <= 2'd0;
                end else if (count == 2'd0) begin
                    // start byte detected, start counting
                    count <= 2'd1;
                end else begin
                    count <= count + 1'b1;
                end
            end
            // else: count stays at 0 and does not toggle
        end
    end

endmodule