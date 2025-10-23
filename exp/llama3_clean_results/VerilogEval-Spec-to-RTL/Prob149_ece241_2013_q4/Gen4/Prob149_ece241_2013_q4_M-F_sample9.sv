module TopModule(
    input  clk,
    input  reset,
    input  [2:0] s,
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
        // Determine the current flow rate based on the sensor inputs 's'
        if (s == 3'b111) begin
            fr2 <= 1'b0;
            fr1 <= 1'b0;
            fr0 <= 1'b0;
        end else if (s == 3'b110) begin
            fr2 <= 1'b0;
            fr1 <= 1'b0;
            fr0 <= 1'b1;
        end else if (s == 3'b100) begin
            fr2 <= 1'b0;
            fr1 <= 1'b1;
            fr0 <= 1'b1;
        end else if (s == 3'b010) begin
            fr2 <= 1'b0;
            fr1 <= 1'b1;
            fr0 <= 1'b1;
        end else if (s == 3'b001) begin
            fr2 <= 1'b1;
            fr1 <= 1'b1;
            fr0 <= 1'b1;
        end else begin
            fr2 <= 1'b1;
            fr1 <= 1'b1;
            fr0 <= 1'b1;
        end
        
        // Determine the 'dfr' signal based on the change in sensor state
        if (s > prev_s) begin
            dfr <= 1'b1;
        end else begin
            dfr <= 1'b0;
        end
        
        // Update the previous sensor state
        prev_s <= s;
    end
end

endmodule