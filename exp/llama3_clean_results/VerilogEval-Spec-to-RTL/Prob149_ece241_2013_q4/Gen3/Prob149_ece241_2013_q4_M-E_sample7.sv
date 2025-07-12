module TopModule(
    input clk,
    input reset,
    input [2:0] s,
    output reg fr2,
    output reg fr1,
    output reg fr0,
    output reg dfr
);

reg [1:0] encoded_value;
reg prev_s;

always @(posedge clk) begin
    if (reset) begin
        // Reset to state equivalent to low water level
        fr2 <= 1'b1;
        fr1 <= 1'b1;
        fr0 <= 1'b1;
        dfr <= 1'b1;
        prev_s <= 3'b000;
    end else begin
        // Priority encoder
        if (s[2]) begin
            encoded_value <= 2'b00;
        end else if (s[1]) begin
            encoded_value <= 2'b01;
        end else if (s[0]) begin
            encoded_value <= 2'b10;
        end else begin
            encoded_value <= 2'b11;
        end

        // Output signal assignments
        case (encoded_value)
            2'b00: begin
                fr2 <= 1'b0;
                fr1 <= 1'b0;
                fr0 <= 1'b0;
                dfr <= 1'b0;
            end
            2'b01: begin
                fr2 <= 1'b0;
                fr1 <= 1'b0;
                fr0 <= 1'b1;
                dfr <= 1'b0;
            end
            2'b10: begin
                fr2 <= 1'b0;
                fr1 <= 1'b1;
                fr0 <= 1'b1;
                dfr <= 1'b0;
            end
            2'b11: begin
                fr2 <= 1'b1;
                fr1 <= 1'b1;
                fr0 <= 1'b1;
                dfr <= 1'b1;
            end
        endcase

        // Check for rising edge on sensor signals to assert dfr
        if ((s != prev_s) && (s > prev_s)) begin
            dfr <= 1'b1;
        end
        prev_s <= s;
    end
end

endmodule