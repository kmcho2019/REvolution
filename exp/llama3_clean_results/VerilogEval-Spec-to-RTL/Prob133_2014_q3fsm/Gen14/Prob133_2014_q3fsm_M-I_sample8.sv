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

reg [1:0] state; // Current state
reg [1:0] cycle_counter; // Counter for cycles
reg [1:0] w_counter; // Counter for w = 1
reg set_z; // Flag to set z in the next clock cycle

always @(posedge clk) begin
    if(reset) begin
        state <= STATE_A;
        cycle_counter <= 0;
        w_counter <= 0;
        z <= 0;
        set_z <= 0;
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
                    set_z <= (w_counter == 2)? 1 : 0;
                    state <= STATE_A;
                    cycle_counter <= 0;
                    w_counter <= 0;
                end
            end
        endcase
        if(set_z) begin
            z <= 1;
            set_z <= 0;
        end
        else begin
            z <= 0;
        end
    end
end

endmodule