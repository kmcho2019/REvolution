module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output done
);

    reg [1:0] cnt;
    reg active;

    always @(posedge clk) begin
        if (reset) begin
            cnt <= 2'b0;
            active <= 1'b0;
        end else begin
            if (!active) begin
                if (in[3]) begin
                    active <= 1'b1;
                    cnt <= 2'b01;
                end
            end else begin
                cnt <= cnt + 1'b1;  // Automatically wraps around
                if (cnt == 2'b10) active <= 1'b0;
            end
        end
    end

    assign done = (cnt == 2'b10) & active;

endmodule