module TopModule(
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

reg [1:0] count; // counter for clock cycles
reg w_count;     // counter for w = 1
reg in_state_b; // flag to indicate if we are in state B
reg prev_z;     // previous value of z

always @(posedge clk or posedge reset) begin
    if (reset) begin
        count <= 0;
        w_count <= 0;
        in_state_b <= 0;
        prev_z <= 0;
        z <= 0;
    end
    else begin
        if (~in_state_b && s) begin // transition from A to B
            in_state_b <= 1;
            count <= 1;
            w_count <= w;
        end
        else if (in_state_b) begin
            count <= count + 1;
            if (w) begin
                w_count <= w_count + 1;
            end
            if (count == 3) begin // end of 3 clock cycles
                if (w_count == 2) begin // set z to 1 in the next cycle
                    prev_z <= 1;
                end
                else begin
                    prev_z <= 0;
                end
                count <= 0;
                w_count <= 0;
            end
        end
        z <= prev_z;
        if (count == 1 && w_count == 2) begin
            prev_z <= 0; // reset prev_z after setting z
        end
    end
end

endmodule