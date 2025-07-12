module TopModule(
    input clk,
    input reset,
    input s,
    input w,
    output reg z // declare z as a reg
);

reg [1:0] state; // 0: State A, 1: State B
reg [1:0] count; // counter for clock cycles
reg w_count;     // counter for w = 1
reg prev_w_count; // to track if we should output z

always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= 0;
        count <= 0;
        w_count <= 0;
        prev_w_count <= 0;
        z <= 0;
    end
    else begin
        case (state)
            0: begin // State A
                if (s) begin
                    state <= 1;
                end
            end
            1: begin // State B
                if (count == 0) begin
                    w_count <= 0;
                end
                if (count < 3) begin
                    count <= count + 1;
                    if (w) begin
                        w_count <= w_count + 1;
                    end
                end
                else begin // count == 3
                    prev_w_count <= w_count;
                    count <= 0;
                end
            end
        endcase
    end
end

assign z = (state == 1 && count == 0 && prev_w_count == 2)? 1 : 0;

endmodule