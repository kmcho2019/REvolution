module TopModule (
    input clk,
    input reset,
    input [2:0] s,
    output fr2,
    output fr1,
    output fr0,
    output dfr
);

reg [3:0] state;
reg [3:0] nextState;

always @(posedge clk) begin
    if (reset) begin
        state <= 4'b1111; // All outputs asserted, no sensors asserted
    end else begin
        state <= nextState;
    end
end

always @(*) begin
    case ({s[2], s[1], s[0]})
        3'b111: begin // Water level above s[2]
            nextState = 4'b0000; // No flow rate outputs asserted
        end
        3'b110, 3'b101: begin // Water level between s[2] and s[1]
            if (state[0]) begin // Previous state was below s[1]
                nextState = 4'b1001; // Nominal flow rate 1, Supplemental flow rate asserted
            end else begin
                nextState = 4'b1000; // Nominal flow rate 1, Supplemental flow rate deasserted
            end
        end
        3'b011, 3'b010: begin // Water level between s[1] and s[0]
            if (state[0]) begin // Previous state was below s[0]
                nextState = 4'b1101; // Nominal flow rate 1 and 2, Supplemental flow rate asserted
            end else begin
                nextState = 4'b1100; // Nominal flow rate 1 and 2, Supplemental flow rate deasserted
            end
        end
        default: begin // Water level below s[0]
            nextState = 4'b1111; // All flow rate outputs asserted
        end
    endcase
end

assign fr2 = state[3];
assign fr1 = state[2];
assign fr0 = state[1];
assign dfr = state[0];

endmodule