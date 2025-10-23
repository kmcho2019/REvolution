module TopModule(
    input clk,
    input reset,
    input [2:0] s,
    output reg fr2,
    output reg fr1,
    output reg fr0,
    output reg dfr
);

reg [1:0] prev_s; // Register to store previous sensor state

// Priority encoder to determine output signals
always @(posedge clk) begin
    if (reset) begin
        fr2 <= 1'b1;
        fr1 <= 1'b1;
        fr0 <= 1'b1;
        dfr <= 1'b1;
        prev_s <= 3'b000;
    end else begin
        prev_s <= s;
        case (1'b1)
            s[2]: begin
                fr2 <= 1'b0;
                fr1 <= 1'b0;
                fr0 <= 1'b0;
            end
            s[1] && !s[2]: begin
                fr2 <= 1'b0;
                fr1 <= 1'b0;
                fr0 <= 1'b1;
            end
            s[0] && !s[1] && !s[2]: begin
                fr2 <= 1'b0;
                fr1 <= 1'b1;
                fr0 <= 1'b1;
            end
            default: begin
                fr2 <= 1'b1;
                fr1 <= 1'b1;
                fr0 <= 1'b1;
            end
        endcase
        // Determine supplemental flow rate signal (dfr)
        if ((s[0] || s[1] || s[2]) && !(prev_s[0] || prev_s[1] || prev_s[2])) begin
            dfr <= 1'b1;
        end else if (s[0] && !prev_s[0]) begin
            dfr <= 1'b1;
        end else if (s[1] && !prev_s[1]) begin
            dfr <= 1'b1;
        end else if (s[2] && !prev_s[2]) begin
            dfr <= 1'b1;
        end else begin
            dfr <= 1'b0;
        end
    end
end

endmodule