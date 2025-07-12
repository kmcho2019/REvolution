module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output reg done
);

    reg [1:0] cnt; // 0=waiting, 1=byte1, 2=byte2

    always @(posedge clk) begin
        if (reset) begin
            cnt <= 2'b00;
            done <= 1'b0;
        end else begin
            done <= (cnt == 2'b10); // Signal done after 3rd byte
            
            if (cnt == 2'b00) begin
                if (in[3]) cnt <= 2'b01; // Start new message
            end else begin
                cnt <= (cnt == 2'b10) ? 2'b00 : cnt + 1; // Increment or reset
            end
        end
    end

endmodule