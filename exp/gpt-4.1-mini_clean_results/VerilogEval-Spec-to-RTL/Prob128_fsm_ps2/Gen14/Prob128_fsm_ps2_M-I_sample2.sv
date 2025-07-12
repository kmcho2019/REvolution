module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output reg done
);

    reg [1:0] count;
    wire start_byte = in[3];
    wire in_message = (count != 2'd0);

    always @(posedge clk) begin
        if (reset) begin
            count <= 2'd0;
            done <= 1'b0;
        end else begin
            done <= 1'b0;  // default done deasserted

            if (!in_message) begin
                // Not in message: look for start byte
                if (start_byte)
                    count <= 2'd1;  // start message counting
            end else begin
                // In message: increment count
                count <= count + 1'b1;
                if (count == 2'd2) begin
                    // On next cycle after third byte, assert done and reset counter
                    done <= 1'b1;
                    count <= 2'd0;
                end
            end
        end
    end

endmodule