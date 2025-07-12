module TopModule (
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

reg [1:0] state; // 0: A, 1: B, 2: C, 3: D
reg [1:0] counter; // count w=1 in the last three clock cycles
reg [1:0] timer; // timer for three clock cycles

always @(posedge clk) begin
    if (reset) begin
        state <= 0;
        counter <= 0;
        timer <= 0;
        z <= 0;
    end else begin
        case (state)
            0: begin // state A
                if (s) begin
                    state <= 1;
                end
            end
            1: begin // state B
                timer <= timer + 1;
                if (w) begin
                    counter <= counter + 1;
                end
                if (timer == 3) begin
                    if (counter == 2) begin
                        z <= 1;
                    end else begin
                        z <= 0;
                    end
                    state <= 1; // stay in state B
                    timer <= 0;
                    counter <= 0;
                end
            end
            default: state <= 0;
        endcase
    end
end

endmodule