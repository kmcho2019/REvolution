module TopModule(
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

reg [2:0] state; // 0: A, 1: B1, 2: B2, 3: B3
reg [2:0] w_history; // history of w for the last three clock cycles

always @(posedge clk) begin
    if(reset) begin
        state <= 3'b000; // State A
        w_history <= 3'b000;
        z <= 1'b0;
    end else begin
        case(state)
            3'b000: begin // State A
                if(s) begin
                    state <= 3'b001; // Transition to State B1
                end
            end
            3'b001: begin // State B1
                w_history[0] <= w;
                state <= 3'b010; // Transition to State B2
            end
            3'b010: begin // State B2
                w_history <= {w, w_history[2:1]};
                state <= 3'b011; // Transition to State B3
            end
            3'b011: begin // State B3
                w_history <= {w, w_history[2:1]};
                if(w_history == 3'b110 || w_history == 3'b101 || w_history == 3'b011) begin
                    z <= 1'b1;
                end else begin
                    z <= 1'b0;
                end
                state <= 3'b001; // Transition back to State B1
            end
        endcase
    end
end

endmodule