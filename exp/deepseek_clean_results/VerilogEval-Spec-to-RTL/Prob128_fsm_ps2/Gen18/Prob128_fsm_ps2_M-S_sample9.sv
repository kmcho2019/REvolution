module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output done
);

    reg [1:0] byte_cnt;

    // Combinational done signal
    assign done = (byte_cnt == 2'b10);

    always @(posedge clk) begin
        if (reset) begin
            byte_cnt <= 2'b0;
        end else begin
            if (byte_cnt == 2'b0) begin
                // Wait for start byte (in[3] == 1)
                if (in[3]) byte_cnt <= 2'b01;
            end else begin
                // Count up to 3 then reset
                byte_cnt <= byte_cnt + 1'b1;
                if (byte_cnt == 2'b10) byte_cnt <= 2'b0;
            end
        end
    end

endmodule