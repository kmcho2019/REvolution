module TopModule(
    input clk,
    input reset,
    input [2:0] s,
    output reg fr2,
    output reg fr1,
    output reg fr0,
    output reg dfr
);

reg [2:0] prev_s;

always @(posedge clk) begin
    if (reset) begin
        // Reset to state equivalent to low water level
        fr2 <= 1'b1;
        fr1 <= 1'b1;
        fr0 <= 1'b1;
        dfr <= 1'b1;
        prev_s <= 3'b000;
    end else begin
        // Update the output signals
        case (s)
            3'b111: begin
                fr2 <= 1'b0;
                fr1 <= 1'b0;
                fr0 <= 1'b0;
            end
            3'b110: begin
                fr2 <= 1'b0;
                fr1 <= 1'b0;
                fr0 <= 1'b1;
            end
            3'b100: begin
                fr2 <= 1'b0;
                fr1 <= 1'b1;
                fr0 <= 1'b1;
            end
            3'b011: begin
                fr2 <= 1'b0;
                fr1 <= 1'b1;
                fr0 <= 1'b1;
            end
            3'b010: begin
                fr2 <= 1'b1;
                fr1 <= 1'b1;
                fr0 <= 1'b1;
            end
            3'b001: begin
                fr2 <= 1'b1;
                fr1 <= 1'b1;
                fr0 <= 1'b1;
            end
            default: begin
                fr2 <= 1'b1;
                fr1 <= 1'b1;
                fr0 <= 1'b1;
            end
        endcase
        
        // Update the dfr signal
        if (s > prev_s) begin
            dfr <= 1'b1;
        end else begin
            case (s)
                3'b111: dfr <= 1'b0;
                3'b110: dfr <= 1'b0;
                3'b100: dfr <= 1'b0;
                3'b011: dfr <= 1'b0;
                3'b010: dfr <= 1'b0;
                3'b001: dfr <= 1'b0;
                default: dfr <= 1'b1;
            endcase
        end
        
        // Update the previous state
        prev_s <= s;
    end
end

endmodule