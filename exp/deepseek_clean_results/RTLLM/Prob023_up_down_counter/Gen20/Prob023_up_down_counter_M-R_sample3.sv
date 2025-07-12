module up_down_counter (
    input clk,
    input reset,
    input up_down,
    output reg [15:0] count
);

// Segment boundaries
localparam SEG0_MAX = 16'h000F;
localparam SEG1_MAX = 16'h00FF;
localparam SEG2_MAX = 16'h0FFF;

always @(posedge clk) begin
    if (reset) begin
        count <= 16'b0;
    end else begin
        if (up_down) begin
            // Increment mode
            if (count[3:0] == 4'b1111) begin
                count[3:0] <= 4'b0;
                if (count[7:4] == 4'b1111) begin
                    count[7:4] <= 4'b0;
                    if (count[11:8] == 4'b1111) begin
                        count[11:8] <= 4'b0;
                        count[15:12] <= count[15:12] + 1'b1;
                    end else begin
                        count[11:8] <= count[11:8] + 1'b1;
                    end
                end else begin
                    count[7:4] <= count[7:4] + 1'b1;
                end
            end else begin
                count[3:0] <= count[3:0] + 1'b1;
            end
        end else begin
            // Decrement mode
            if (count[3:0] == 4'b0000) begin
                count[3:0] <= 4'b1111;
                if (count[7:4] == 4'b0000) begin
                    count[7:4] <= 4'b1111;
                    if (count[11:8] == 4'b0000) begin
                        count[11:8] <= 4'b1111;
                        count[15:12] <= count[15:12] - 1'b1;
                    end else begin
                        count[11:8] <= count[11:8] - 1'b1;
                    end
                end else begin
                    count[7:4] <= count[7:4] - 1'b1;
                end
            end else begin
                count[3:0] <= count[3:0] - 1'b1;
            end
        end
    end
end

endmodule