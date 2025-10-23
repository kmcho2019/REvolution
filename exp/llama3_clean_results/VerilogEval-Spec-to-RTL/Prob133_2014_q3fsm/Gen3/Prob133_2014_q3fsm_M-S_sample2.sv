module TopModule(
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

reg [1:0] state; // 0 - state A, 1 - state B
reg [2:0] w_count; // Combined counter for w = 1 occurrences and 3-cycle window

always @(posedge clk) begin
    if(reset) begin
        state <= 0;
        w_count <= 0;
        z <= 0;
    end
    else begin
        case(state)
            0: begin // state A
                if(s) begin
                    state <= 1;
                    w_count <= 0;
                end
            end
            1: begin // state B
                if(w) begin
                    w_count[0] <= 1'b1;
                end
                w_count[2:1] <= w_count[1:0];
                if(w_count[2]) begin
                    if(w_count[1:0] == 2'b10 || w_count[1:0] == 2'b01) begin
                        z <= 1;
                    end
                    else begin
                        z <= 0;
                    end
                    w_count <= 0;
                end
            end
            default: state <= 0;
        endcase
    end
end

endmodule