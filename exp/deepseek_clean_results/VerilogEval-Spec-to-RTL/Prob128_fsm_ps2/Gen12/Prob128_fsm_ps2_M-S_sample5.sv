module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output done
);

    reg [1:0] cnt;

    always @(posedge clk) begin
        if (reset) begin
            cnt <= 2'b0;
        end else begin
            if (cnt == 2'b0) begin
                if (in[3]) cnt <= 2'b01;  // Start counting on first byte with in[3]=1
            end else begin
                cnt <= (cnt == 2'b10) ? 2'b0 : cnt + 1'b1;  // Wrap around after 3 bytes
            end
        end
    end

    assign done = (cnt == 2'b10);  // Assert done when third byte is received

endmodule