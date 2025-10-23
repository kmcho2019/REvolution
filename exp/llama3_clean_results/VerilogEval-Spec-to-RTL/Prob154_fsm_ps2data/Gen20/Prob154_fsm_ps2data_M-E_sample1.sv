module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output reg [23:0] out_bytes,
    output reg done
);

reg [1:0] counter;

always @(posedge clk) begin
    if (reset) begin
        counter <= 2'b0;
        out_bytes <= 24'b0;
        done <= 1'b0;
    end else begin
        if (in[3] == 1'b1) begin
            // Reset counter and store first byte
            counter <= 2'b1;
            out_bytes <= {in, 16'b0};
            done <= 1'b0;
        end else if (counter == 2'b1) begin
            // Store second byte
            counter <= 2'b2;
            out_bytes <= {out_bytes[15:0], in};
            done <= 1'b0;
        end else if (counter == 2'b2) begin
            // Store third byte and assert done
            counter <= 2'b0;
            out_bytes <= {out_bytes[7:0], in, 8'b0};
            done <= 1'b1;
        end else begin
            // Idle state
            counter <= 2'b0;
            done <= 1'b0;
        end
    end
end

endmodule