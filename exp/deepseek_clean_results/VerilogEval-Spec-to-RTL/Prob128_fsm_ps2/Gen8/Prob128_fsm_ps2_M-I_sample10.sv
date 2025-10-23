module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output done
);

    reg [1:0] cnt;
    reg in_message;

    // Combinational done signal
    assign done = (cnt == 2'b10);

    always @(posedge clk) begin
        if (reset) begin
            cnt <= 2'b0;
            in_message <= 1'b0;
        end else begin
            if (!in_message) begin
                // Wait for start of message
                if (in[3]) begin
                    cnt <= 2'b01;
                    in_message <= 1'b1;
                end
            end else begin
                // Message in progress
                cnt <= cnt + 1'b1;
                if (cnt == 2'b10) begin
                    // Message complete
                    in_message <= 1'b0;
                end
            end
        end
    end

endmodule