module serial2parallel (
    input           clk,
    input           rst_n,
    input           din_serial,
    input           din_valid,
    output reg [7:0] dout_parallel,
    output reg      dout_valid
);

    reg [3:0] cnt;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            dout_parallel <= 8'd0;
            dout_valid    <= 1'b0;
            cnt           <= 4'd0;
        end else begin
            dout_valid <= 1'b0; // default no valid output

            if (din_valid) begin
                dout_parallel[7 - cnt] <= din_serial; // store bit at corresponding position
                if (cnt == 4'd7) begin
                    dout_valid <= 1'b1; // assert output valid on last bit received
                    cnt <= 4'd0;        // reset counter for next 8-bit sequence
                end else begin
                    cnt <= cnt + 1'b1;
                end
            end
        end
    end

endmodule