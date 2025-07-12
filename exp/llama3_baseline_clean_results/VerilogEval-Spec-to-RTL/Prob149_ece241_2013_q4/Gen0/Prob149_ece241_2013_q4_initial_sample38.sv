module TopModule(
    input  clk,
    input  reset,
    input  [2:0] s,
    output reg fr2,
    output reg fr1,
    output reg fr0,
    output reg dfr
);

reg [1:0] current_state;
reg [1:0] next_state;
reg [2:0] previous_s;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        current_state <= 2'b00; // Reset to state 0
        fr2 <= 1'b1;
        fr1 <= 1'b1;
        fr0 <= 1'b1;
        dfr <= 1'b1;
    end else begin
        previous_s <= s;
        case (current_state)
            2'b00: begin // Water level is below the lowest sensor s[0]
                if (s[0] == 1'b1) begin
                    current_state <= 2'b01;
                    fr2 <= 1'b0;
                    fr1 <= 1'b1;
                    fr0 <= 1'b1;
                    dfr <= 1'b1;
                end else begin
                    fr2 <= 1'b1;
                    fr1 <= 1'b1;
                    fr0 <= 1'b1;
                    dfr <= 1'b1;
                end
            end
            2'b01: begin // Water level is between s[0] and s[1]
                if (s[1] == 1'b1 && previous_s[1] == 1'b0) begin
                    current_state <= 2'b10;
                    fr2 <= 1'b0;
                    fr1 <= 1'b0;
                    fr0 <= 1'b1;
                    dfr <= 1'b1;
                end else if (s[0] == 1'b0 && previous_s[0] == 1'b1) begin
                    current_state <= 2'b00;
                    fr2 <= 1'b1;
                    fr1 <= 1'b1;
                    fr0 <= 1'b1;
                    dfr <= 1'b1;
                end else if (s[1] == 1'b0 && previous_s[1] == 1'b0 && s[0] == 1'b1 && previous_s[0] == 1'b0) begin
                    current_state <= 2'b01;
                    fr2 <= 1'b0;
                    fr1 <= 1'b1;
                    fr0 <= 1'b1;
                    dfr <= 1'b1;
                end else begin
                    fr2 <= 1'b0;
                    fr1 <= 1'b1;
                    fr0 <= 1'b1;
                    dfr <= 1'b0;
                end
            end
            2'b10: begin // Water level is between s[1] and s[2]
                if (s[2] == 1'b1 && previous_s[2] == 1'b0) begin
                    current_state <= 2'b11;
                    fr2 <= 1'b0;
                    fr1 <= 1'b0;
                    fr0 <= 1'b0;
                    dfr <= 1'b0;
                end else if (s[1] == 1'b0 && previous_s[1] == 1'b1) begin
                    current_state <= 2'b01;
                    fr2 <= 1'b0;
                    fr1 <= 1'b1;
                    fr0 <= 1'b1;
                    dfr <= 1'b1;
                end else if (s[2] == 1'b0 && previous_s[2] == 1'b0 && s[1] == 1'b1 && previous_s[1] == 1'b0) begin
                    current_state <= 2'b10;
                    fr2 <= 1'b0;
                    fr1 <= 1'b0;
                    fr0 <= 1'b1;
                    dfr <= 1'b1;
                end else begin
                    fr2 <= 1'b0;
                    fr1 <= 1'b0;
                    fr0 <= 1'b1;
                    dfr <= 1'b0;
                end
            end
            2'b11: begin // Water level is above the highest sensor s[2]
                fr2 <= 1'b0;
                fr1 <= 1'b0;
                fr0 <= 1'b0;
                dfr <= 1'b0;
            end
        endcase
    end
end

endmodule