module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output done
);

    reg [1:0] byte_cnt;
    reg done_reg;

    always @(posedge clk) begin
        if (reset) begin
            byte_cnt <= 2'b0;
            done_reg <= 1'b0;
        end else begin
            // Default assignments
            done_reg <= 1'b0;
            
            // Update counter and detect message completion
            if (byte_cnt == 2'b0) begin
                if (in[3]) byte_cnt <= 2'b01;
            end else begin
                if (byte_cnt == 2'b10) begin
                    done_reg <= 1'b1;
                    byte_cnt <= 2'b0;
                end else begin
                    byte_cnt <= byte_cnt + 1'b1;
                end
            end
        end
    end

    assign done = done_reg;

endmodule