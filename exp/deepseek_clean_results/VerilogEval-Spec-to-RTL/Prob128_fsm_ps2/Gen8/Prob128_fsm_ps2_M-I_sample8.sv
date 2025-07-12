module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output done
);

    reg [1:0] cnt;
    reg in_message;

    always @(posedge clk) begin
        if (reset) begin
            cnt <= 2'b0;
            in_message <= 1'b0;
        end else begin
            if (!in_message) begin
                if (in[3]) begin
                    in_message <= 1'b1;
                    cnt <= 2'b01;
                end
            end else begin
                cnt <= cnt + 1'b1;
                if (cnt == 2'b10) begin
                    in_message <= 1'b0;
                end
            end
        end
    end

    assign done = in_message && (cnt == 2'b10);

endmodule