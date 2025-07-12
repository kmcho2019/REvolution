module TopModule(
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

reg [1:0] state; // 0: State A, 1: State B (counting), 2: State B (checking), 3: State B (output)
reg [1:0] w_count; // Count of w over the three-clock cycle window

always @(posedge clk or posedge reset) begin
    if(reset) begin
        state <= 0;
        w_count <= 0;
        z <= 0;
    end else begin
        case(state)
            0: begin // State A
                if(s) begin
                    state <= 1;
                end
            end
            1: begin // State B (counting)
                if(w) begin
                    w_count <= w_count + 1;
                end
                state <= state + 1;
            end
            2: begin // State B (checking)
                if(w) begin
                    w_count <= w_count + 1;
                end
                state <= state + 1;
            end
            3: begin // State B (output)
                z <= (w_count == 2) ? 1 : 0;
                w_count <= 0;
                state <= 1;
            end
        endcase
    end
end

endmodule