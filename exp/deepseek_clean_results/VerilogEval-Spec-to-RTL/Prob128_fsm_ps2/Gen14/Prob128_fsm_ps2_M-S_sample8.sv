module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output reg done
);

    reg in_message;
    reg [1:0] cnt;

    always @(posedge clk) begin
        if (reset) begin
            in_message <= 1'b0;
            cnt <= 2'b0;
            done <= 1'b0;
        end else begin
            done <= (in_message && (cnt == 2'b10));
            
            if (in_message) begin
                cnt <= cnt + 1'b1;
                if (cnt == 2'b10) begin
                    in_message <= 1'b0;
                end
            end else if (in[3]) begin
                in_message <= 1'b1;
                cnt <= 2'b01;
            end
        end
    end

endmodule