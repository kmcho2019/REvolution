module TopModule(
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

reg [1:0] state; // 2 states: A (0) and B (1)
reg [2:0] count; // Counter for clock cycles after entering state B
reg [1:0] w_count; // Counter for w = 1 in the last 3 clock cycles
reg z_next; // Next value of z

// State encoding
parameter A = 0, B = 1;

always @(posedge clk or posedge reset) begin
    if(reset) begin
        state <= A;
        count <= 0;
        w_count <= 0;
        z <= 0;
    end else begin
        case(state)
            A: begin
                if(s) begin
                    state <= B;
                    count <= 1;
                    if(w) w_count <= 1; else w_count <= 0;
                    z <= 0;
                end else begin
                    state <= A;
                    count <= 0;
                    w_count <= 0;
                    z <= 0;
                end
            end
            B: begin
                count <= count + 1;
                if(w) w_count <= w_count + 1;
                if(count == 3) begin
                    if(w_count == 2) z_next <= 1; else z_next <= 0;
                    count <= 0;
                    w_count <= 0;
                    state <= B; // Remain in state B
                end else begin
                    z_next <= 0;
                end
            end
            default: begin
                state <= A;
                count <= 0;
                w_count <= 0;
                z <= 0;
            end
        endcase
        z <= z_next;
    end
end

endmodule