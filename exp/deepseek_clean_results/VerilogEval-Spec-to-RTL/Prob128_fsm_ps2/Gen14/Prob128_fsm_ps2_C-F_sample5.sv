module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output reg done
);

    reg [1:0] byte_cnt;
    wire next_done;

    // Combinational output logic
    assign next_done = (byte_cnt == 2'b10);

    always @(posedge clk) begin
        if (reset) begin
            byte_cnt <= 2'b0;
            done <= 1'b0;
        end else begin
            done <= next_done;
            
            if (byte_cnt == 2'b0) begin
                // Only check in[3] when waiting for start byte
                byte_cnt <= in[3] ? 2'b01 : 2'b0;
            end else begin
                // Auto-reset after 3 bytes
                byte_cnt <= (byte_cnt == 2'b10) ? 2'b0 : byte_cnt + 1'b1;
            end
        end
    end

endmodule