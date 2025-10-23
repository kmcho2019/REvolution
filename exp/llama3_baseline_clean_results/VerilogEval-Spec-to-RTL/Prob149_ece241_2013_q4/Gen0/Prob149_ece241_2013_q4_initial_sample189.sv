module TopModule(
    input  clk,
    input  reset,
    input  [2:0] s,
    output reg fr2,
    output reg fr1,
    output reg fr0,
    output reg dfr
);

reg [2:0] curr_state;
reg [2:0] prev_state;

always @(posedge clk) begin
    if (reset) begin
        curr_state <= 3'b000;
        prev_state <= 3'b000;
        fr2 <= 1'b1;
        fr1 <= 1'b1;
        fr0 <= 1'b1;
        dfr <= 1'b1;
    end else begin
        prev_state <= curr_state;
        if (s == 3'b111) begin
            curr_state <= 3'b111;
        end else if (s == 3'b110) begin
            curr_state <= 3'b110;
        end else if (s == 3'b100) begin
            curr_state <= 3'b100;
        end else if (s == 3'b000) begin
            curr_state <= 3'b000;
        end else begin
            curr_state <= curr_state;
        end

        if (curr_state == 3'b111) begin
            fr2 <= 1'b0;
            fr1 <= 1'b0;
            fr0 <= 1'b0;
            dfr <= 1'b0;
        end else if (curr_state == 3'b110) begin
            fr2 <= 1'b0;
            fr1 <= 1'b0;
            fr0 <= 1'b1;
            dfr <= (prev_state < curr_state)? 1'b1 : 1'b0;
        end else if (curr_state == 3'b100) begin
            fr2 <= 1'b0;
            fr1 <= 1'b1;
            fr0 <= 1'b1;
            dfr <= (prev_state < curr_state)? 1'b1 : 1'b0;
        end else begin
            fr2 <= 1'b1;
            fr1 <= 1'b1;
            fr0 <= 1'b1;
            dfr <= (prev_state < curr_state)? 1'b1 : 1'b0;
        end
    end
end

endmodule