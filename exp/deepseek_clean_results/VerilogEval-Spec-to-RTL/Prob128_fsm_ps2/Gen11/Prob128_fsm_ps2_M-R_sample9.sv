module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output done
);

    reg [1:0] byte_cnt, next_byte_cnt;

    // Combinational next state logic
    always @(*) begin
        if (byte_cnt == 2'b0) begin
            next_byte_cnt = in[3] ? 2'b01 : 2'b00;
        end else begin
            next_byte_cnt = (byte_cnt == 2'b10) ? 2'b00 : (byte_cnt + 1'b1);
        end
    end

    // Sequential state update
    always @(posedge clk) begin
        if (reset) begin
            byte_cnt <= 2'b0;
        end else begin
            byte_cnt <= next_byte_cnt;
        end
    end

    // Combinational output
    assign done = (byte_cnt == 2'b10);

endmodule