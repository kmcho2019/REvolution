module TopModule(
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

parameter A = 2'b00, B_ENTER = 2'b01, B_WAIT1 = 2'b10, B_WAIT2 = 2'b11;

reg [1:0] state;
reg [1:0] w_count;
reg [1:0] cycle_count;

always @(posedge clk) begin
    if(reset) begin
        state <= A;
        w_count <= 2'b00;
        cycle_count <= 2'b00;
        z <= 1'b0;
    end else begin
        case(state)
            A: begin
                if(s) begin
                    state <= B_ENTER;
                    w_count <= 2'b00;
                    cycle_count <= 2'b00;
                end
            end
            B_ENTER: begin
                if(w) begin
                    w_count <= w_count + 1'b1;
                end
                cycle_count <= cycle_count + 1'b1;
                state <= B_WAIT1;
            end
            B_WAIT1: begin
                if(w) begin
                    w_count <= w_count + 1'b1;
                end
                cycle_count <= cycle_count + 1'b1;
                state <= B_WAIT2;
            end
            B_WAIT2: begin
                if(w) begin
                    w_count <= w_count + 1'b1;
                end
                cycle_count <= cycle_count + 1'b1;
                if(w_count == 2'b10) begin
                    z <= 1'b1;
                end else begin
                    z <= 1'b0;
                end
                state <= B_ENTER;
                w_count <= 2'b00;
                cycle_count <= 2'b00;
            end
            default: ;
        endcase
    end
end

endmodule