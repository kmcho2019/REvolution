module TopModule (
    input clk,
    input reset,
    input in,
    output reg disc,
    output reg flag,
    output reg err
);

    // State encoding - now using 4 bits to accommodate all states
    localparam [3:0] 
        S_RESET = 4'd0,
        S_0     = 4'd1,
        S_1     = 4'd2,
        S_2     = 4'd3,
        S_3     = 4'd4,
        S_4     = 4'd5,
        S_5     = 4'd6,
        S_6     = 4'd7,
        S_ERROR = 4'd8;

    reg [3:0] current_state, next_state;

    // Next state logic (combinational)
    always @(*) begin
        case (current_state)
            S_RESET: next_state = in ? S_1 : S_0;
            S_0:     next_state = in ? S_1 : S_0;
            S_1:     next_state = in ? S_2 : S_0;
            S_2:     next_state = in ? S_3 : S_0;
            S_3:     next_state = in ? S_4 : S_0;
            S_4:     next_state = in ? S_5 : S_0;
            S_5:     next_state = in ? S_6 : S_0;
            S_6:     next_state = in ? S_ERROR : S_0;
            S_ERROR: next_state = in ? S_ERROR : S_0;
            default: next_state = S_0;
        endcase
    end

    // State transition and output registration (sequential)
    always @(posedge clk) begin
        if (reset) begin
            current_state <= S_RESET;
            disc <= 0;
            flag <= 0;
            err <= 0;
        end else begin
            current_state <= next_state;
            
            // Outputs are registered versions of combinational conditions
            disc <= (current_state == S_5) && !in;
            flag <= (current_state == S_6) && !in;
            err <= (current_state == S_ERROR);
        end
    end

endmodule