module TopModule(
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

reg [2:0] w_shift; // shift register to track 'w' values
reg in_state_b; // flag to indicate if we are in state B

always @(posedge clk or posedge reset) begin
    if (reset) begin
        w_shift <= 3'b000;
        in_state_b <= 0;
        z <= 0;
    end
    else begin
        if (~in_state_b && s) begin // transition from A to B
            in_state_b <= 1;
            w_shift <= {w, 2'b00};
        end
        else if (in_state_b) begin
            w_shift <= {w, w_shift[2:1]}; // shift in current 'w'
            if (w_shift == 3'b101 || w_shift == 3'b110 || w_shift == 3'b011 || w_shift == 3'b100 || w_shift == 3'b010) begin // check for exactly two 'w' = 1
                z <= 1;
            end
            else begin
                z <= 0;
            end
        end
    end
end

endmodule