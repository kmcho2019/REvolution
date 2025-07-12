module TopModule(
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

reg [1:0] state; // 0 - state A, 1 - counting w in state B, 2 - set z based on count of w, 3 - reset state after setting z
reg [1:0] w_count; // count of w = 1 over the last two clock cycles
reg [1:0] count; // count of clock cycles after transitioning to state B

always @(posedge clk) begin
    if(reset) begin
        state <= 0;
        w_count <= 0;
        count <= 0;
        z <= 0;
    end
    else begin
        case(state)
            0: begin // state A
                if(s) begin
                    state <= 1;
                    w_count <= 0;
                    count <= 0;
                end
            end
            1: begin // start counting w in state B
                if(count == 3) begin
                    state <= 2;
                    if(w_count == 2) begin
                        z <= 1;
                    end
                    else begin
                        z <= 0;
                    end
                end
                else begin
                    if(w) begin
                        w_count <= w_count + 1;
                    end
                    count <= count + 1;
                    if(count == 2) begin
                        state <= 1;
                    end
                    else if(count == 3) begin
                        state <= 2;
                    end
                end
            end
            2: begin
                state <= 1;
                w_count <= 0;
                count <= 0;
            end
            default: state <= 0;
        endcase
    end
end

endmodule