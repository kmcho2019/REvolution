module TopModule(
    input  clk,
    input  reset,
    input  s,
    input  w,
    output reg z
);

reg [1:0] state; // 0: A, 1: B
reg [1:0] count; // counter for 3 clock cycles
reg w_count; // count of w = 1 in 3 clock cycles
reg set_z; // flag to set z to 1

always @(posedge clk) begin
    if (reset) begin
        state <= 0; // reset to state A
        count <= 0;
        w_count <= 0;
        set_z <= 0;
        z <= 0;
    end else begin
        case (state)
            0: begin // state A
                if (s) begin
                    state <= 1; // move to state B
                    count <= 1;
                    w_count <= w;
                end else begin
                    state <= 0; // stay in state A
                end
                set_z <= 0;
                z <= 0;
            end
            1: begin // state B
                if (count == 3) begin // end of 3 clock cycles
                    if (w_count == 2) begin
                        set_z <= 1; // set flag to set z to 1
                    end else begin
                        set_z <= 0;
                    end
                    count <= 1; // reset counter
                    w_count <= w; // reset w count
                    state <= 1; // stay in state B
                end else begin
                    count <= count + 1; // increment counter
                    w_count <= w_count + w; // increment w count
                    state <= 1; // stay in state B
                end
                if (set_z) begin
                    z <= 1; // set z to 1
                    set_z <= 0; // reset flag
                end else begin
                    z <= 0;
                end
            end
        endcase
    end
end

endmodule