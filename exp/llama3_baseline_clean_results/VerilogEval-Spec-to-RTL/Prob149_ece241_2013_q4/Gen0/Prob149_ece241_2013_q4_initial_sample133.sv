module TopModule(
    input  clk,
    input  reset,
    input  [2:0] s,  // 3-bit input for sensors
    output fr2,
    output fr1,
    output fr0,
    output dfr
);

reg [2:0] prev_s;  // register to store the previous state of sensors

always @(posedge clk) begin
    if (reset) begin  // active-high synchronous reset
        prev_s <= 3'b000;  // reset to initial state
        fr2 <= 1'b1;
        fr1 <= 1'b1;
        fr0 <= 1'b1;
        dfr <= 1'b1;
    end else begin
        // determine the nominal flow rate
        if (s == 3'b111) begin  // above s[2]
            fr2 <= 1'b0;
            fr1 <= 1'b0;
            fr0 <= 1'b0;
            dfr <= 1'b0;
        end else if (s == 3'b011) begin  // between s[2] and s[1]
            fr2 <= 1'b0;
            fr1 <= 1'b0;
            fr0 <= 1'b1;
            if (prev_s < s) begin  // previous level was lower
                dfr <= 1'b1;
            end else begin
                dfr <= 1'b0;
            end
        end else if (s == 3'b001) begin  // between s[1] and s[0]
            fr2 <= 1'b0;
            fr1 <= 1'b1;
            fr0 <= 1'b1;
            if (prev_s < s) begin  // previous level was lower
                dfr <= 1'b1;
            end else begin
                dfr <= 1'b0;
            end
        end else begin  // below s[0]
            fr2 <= 1'b1;
            fr1 <= 1'b1;
            fr0 <= 1'b1;
            if (prev_s < s) begin  // previous level was lower
                dfr <= 1'b1;
            end else begin
                dfr <= 1'b0;
            end
        end
        
        // update the previous state
        prev_s <= s;
    end
end

endmodule