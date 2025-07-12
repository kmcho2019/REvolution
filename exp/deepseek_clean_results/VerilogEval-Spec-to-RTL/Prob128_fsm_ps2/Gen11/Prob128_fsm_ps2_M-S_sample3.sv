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
                if (in[3]) cnt <= 2'b01;  // Start message
            end else begin
                cnt <= (cnt == 2'b11) ? 2'b0 : cnt + 1'b1;  // Increment or wrap
            end
        end
    end

    assign done = (cnt == 2'b11);  // Done when about to receive byte3

endmodule