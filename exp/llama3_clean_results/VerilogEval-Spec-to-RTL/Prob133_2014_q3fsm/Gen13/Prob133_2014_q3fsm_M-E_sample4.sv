module TopModule(
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

// Define states
localparam STATE_A = 2'b00;
localparam STATE_B = 2'b01;
localparam STATE_C = 2'b10;

reg [1:0] state; // Current state
reg [1:0] cycle_counter; // Counter for cycles
reg [1:0] w_counter; // Counter for w = 1

always @(posedge clk) begin
    if(reset) begin
        state <= STATE_A;
        cycle_counter <= 0;
        w_counter <= 0;
        z <= 0;
    end
    else begin
        case(state)
            STATE_A: begin
                if(s) begin
                    state <= STATE_B;
                    cycle_counter <= 1;
                    w_counter <= w? 1 : 0;
                end
                else begin
                    state <= STATE_A;
                    z <= 0;
                end
            end
            STATE_B: begin
                if(w) begin
                    w_counter <= w_counter + 1;
                end
                cycle_counter <= cycle_counter + 1;
                if(cycle_counter == 3) begin
                    state <= STATE_C;
                end
                if(!s) begin
                    state <= STATE_A;
                    z <= 0;
                end
            end
            STATE_C: begin
                z <= (w_counter == 2)? 1 : 0;
                state <= STATE_B;
                cycle_counter <= 1;
                w_counter <= w? 1 : 0;
            end
        endcase
    end
end

endmodule