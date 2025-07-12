module TopModule(
    input clk,
    input reset,
    input [2:0] s,
    output fr2,
    output fr1,
    output fr0,
    output dfr
);

reg [1:0] state; // 00: above s[2], 01: between s[2] and s[1], 10: between s[1] and s[0], 11: below s[0]
reg [1:0] prev_state; // previous state

always @(posedge clk) begin
    if (reset) begin
        state <= 2'b11; // reset to state below s[0]
        fr2 <= 1'b1;
        fr1 <= 1'b1;
        fr0 <= 1'b1;
        dfr <= 1'b1;
    end else begin
        // determine current state
        if (s[2]) begin
            state <= 2'b00; // above s[2]
        end else if (s[1]) begin
            state <= 2'b01; // between s[2] and s[1]
        end else if (s[0]) begin
            state <= 2'b10; // between s[1] and s[0]
        end else begin
            state <= 2'b11; // below s[0]
        end
        
        // update previous state
        prev_state <= state;
        
        // determine outputs
        case (state)
            2'b00: begin // above s[2]
                fr2 <= 1'b0;
                fr1 <= 1'b0;
                fr0 <= 1'b0;
                dfr <= 1'b0;
            end
            2'b01: begin // between s[2] and s[1]
                fr2 <= 1'b0;
                fr1 <= 1'b0;
                fr0 <= 1'b1;
                if (prev_state == 2'b00) begin // rising
                    dfr <= 1'b1;
                end else begin
                    dfr <= 1'b0;
                end
            end
            2'b10: begin // between s[1] and s[0]
                fr2 <= 1'b0;
                fr1 <= 1'b1;
                fr0 <= 1'b1;
                if (prev_state == 2'b01) begin // rising
                    dfr <= 1'b1;
                end else begin
                    dfr <= 1'b0;
                end
            end
            2'b11: begin // below s[0]
                fr2 <= 1'b1;
                fr1 <= 1'b1;
                fr0 <= 1'b1;
                dfr <= 1'b1;
            end
        endcase
    end
end

endmodule