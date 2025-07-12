module TopModule(
    input clk,
    input reset,
    input [2:0] s,
    output fr2,
    output fr1,
    output fr0,
    output dfr
);

reg [2:0] prev_s; // previous sensor state
reg [2:0] curr_s; // current sensor state

always @(*) begin
    curr_s = s;
end

always @(posedge clk) begin
    if (reset) begin
        // reset to state equivalent to water level being low for a long time
        fr2 <= 1'b1;
        fr1 <= 1'b1;
        fr0 <= 1'b1;
        dfr <= 1'b1;
        prev_s <= 3'b000;
    end else begin
        // determine flow rate based on current sensor state
        if (curr_s == 3'b111) begin
            // above highest sensor
            fr2 <= 1'b0;
            fr1 <= 1'b0;
            fr0 <= 1'b0;
            dfr <= 1'b0;
        end else if (curr_s == 3'b011) begin
            // between highest and middle sensors
            fr2 <= 1'b0;
            fr1 <= 1'b0;
            fr0 <= 1'b1;
            if (prev_s < curr_s) begin
                dfr <= 1'b1;
            end else begin
                dfr <= 1'b0;
            end
        end else if (curr_s == 3'b001) begin
            // between middle and lowest sensors
            fr2 <= 1'b0;
            fr1 <= 1'b1;
            fr0 <= 1'b1;
            if (prev_s < curr_s) begin
                dfr <= 1'b1;
            end else begin
                dfr <= 1'b0;
            end
        end else begin
            // below lowest sensor
            fr2 <= 1'b1;
            fr1 <= 1'b1;
            fr0 <= 1'b1;
            dfr <= 1'b1;
        end
        prev_s <= curr_s;
    end
end

endmodule