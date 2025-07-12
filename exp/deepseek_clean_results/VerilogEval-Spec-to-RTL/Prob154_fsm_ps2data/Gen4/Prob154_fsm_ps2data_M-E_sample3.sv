module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output reg [23:0] out_bytes,
    output reg done
);

    reg [1:0] valid_count;
    reg [2:0] pipeline;
    reg prev_in3;
    wire start_condition;

    // Edge detection for start condition
    assign start_condition = in[3] & ~prev_in3;

    always @(posedge clk) begin
        if (reset) begin
            valid_count <= 2'b0;
            pipeline <= 3'b0;
            prev_in3 <= 1'b0;
            done <= 1'b0;
        end else begin
            prev_in3 <= in[3];
            done <= 1'b0;

            // Shift pipeline and input byte
            out_bytes <= {out_bytes[15:0], in};
            pipeline <= {pipeline[1:0], start_condition};

            // Update valid count
            if (pipeline[2]) begin  // Start condition was detected 2 cycles ago
                if (valid_count == 2'b10) begin
                    valid_count <= 2'b0;
                    done <= 1'b1;
                end else begin
                    valid_count <= valid_count + 1'b1;
                end
            end else if (valid_count != 2'b0) begin
                // Continue counting if we're in the middle of a message
                if (valid_count == 2'b10) begin
                    valid_count <= 2'b0;
                    done <= 1'b1;
                end else begin
                    valid_count <= valid_count + 1'b1;
                end
            end
        end
    end

endmodule