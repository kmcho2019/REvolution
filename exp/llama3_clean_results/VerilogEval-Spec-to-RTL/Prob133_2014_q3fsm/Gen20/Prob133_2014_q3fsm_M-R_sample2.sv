module TopModule(
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

typedef enum logic [1:0] {
    A = 2'b00,
    B = 2'b01
} state_t;
state_t state;

reg [1:0] cycle_count;
reg [1:0] w_count;

always @(posedge clk) begin
    if(reset) begin
        state <= A;
        cycle_count <= 2'b00;
        w_count <= 2'b00;
        z <= 1'b0;
    end else begin
        case(state)
            A: begin
                if(s) begin
                    state <= B;
                    cycle_count <= 2'b01;
                    w_count <= w ? 2'b01 : 2'b00;
                end
            end
            B: begin
                if(cycle_count == 2'b11) begin
                    z <= (w_count == 2'b10) ? 1'b1 : 1'b0;
                    state <= B;
                    cycle_count <= 2'b01;
                    w_count <= w ? 2'b01 : 2'b00;
                end else begin
                    cycle_count <= cycle_count + 1'b1;
                    w_count <= w_count + (w ? 1'b1 : 1'b0);
                end
            end
            default: state <= A; // Handle unintended states by resetting to A
        endcase
    end
end

endmodule