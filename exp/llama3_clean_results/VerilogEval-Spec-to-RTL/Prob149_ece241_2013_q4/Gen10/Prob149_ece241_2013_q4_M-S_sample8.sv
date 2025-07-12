module TopModule(
    input  clk,
    input  reset,
    input [2:0] s,
    output reg fr2,
    output reg fr1,
    output reg fr0,
    output reg dfr
);

reg [2:0] prev_s;

always @(posedge clk) begin
    if (reset) begin
        fr2 <= 1'b1;
        fr1 <= 1'b1;
        fr0 <= 1'b1;
        dfr <= 1'b1;
        prev_s <= 3'b000;
    end else begin
        prev_s <= s;

        if (s == 3'b000) begin
            // Water level is below the lowest sensor
            fr2 <= 1'b1;
            fr1 <= 1'b1;
            fr0 <= 1'b1;
            dfr <= 1'b1;
        end else if (s == 3'b111) begin
            // Water level is above the highest sensor
            fr2 <= 1'b0;
            fr1 <= 1'b0;
            fr0 <= 1'b0;
            dfr <= 1'b0;
        end else if (s == 3'b001) begin
            // Water level is below the middle sensor but above the lowest sensor
            fr2 <= 1'b1;
            fr1 <= 1'b1;
            fr0 <= 1'b0;
            dfr <= (prev_s < s) ? 1'b1 : 1'b0;
        end else if (s == 3'b011) begin
            // Water level is below the highest sensor but above the middle sensor
            fr2 <= 1'b1;
            fr1 <= 1'b0;
            fr0 <= 1'b0;
            dfr <= (prev_s < s) ? 1'b1 : 1'b0;
        end else begin
            // Default case
            fr2 <= 1'b0;
            fr1 <= 1'b0;
            fr0 <= 1'b0;
            dfr <= 1'b0;
        end
    end
end

endmodule