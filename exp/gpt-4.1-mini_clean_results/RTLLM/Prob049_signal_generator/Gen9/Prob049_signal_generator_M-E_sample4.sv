module signal_generator (
    input            clk,
    input            rst_n,
    output reg [4:0] wave
);

    reg [5:0] count; // 6-bit counter counts from 0 to 62

    always @(posedge clk or negedge rst_n) begin
        if (~rst_n)
            count <= 6'd0;
        else begin
            if (count == 6'd62)
                count <= 6'd0;
            else
                count <= count + 6'd1;
        end
    end

    always @(*) begin
        if (count <= 6'd31)
            wave = count[4:0];
        else
            wave = 6'd62 - count; // reflect to create decrement
    end

endmodule