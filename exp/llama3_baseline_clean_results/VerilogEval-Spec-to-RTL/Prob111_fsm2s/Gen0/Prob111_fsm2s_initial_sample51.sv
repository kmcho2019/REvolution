module TopModule(clk, reset, j, k, out);
    input clk, reset, j, k;
    output out;
    reg [1:0] state; // 0 - OFF, 1 - ON
    reg [1:0] next_state;

    // Define states
    parameter OFF = 0, ON = 1;

    // Output logic
    assign out = (state == ON) ? 1'b1 : 1'b0;

    // Next state logic
    always @(*) begin
        case(state)
            OFF: begin
                if(j) next_state = ON;
                else next_state = OFF;
            end
            ON: begin
                if(k) next_state = OFF;
                else next_state = ON;
            end
            default: next_state = OFF;
        endcase
    end

    // State register
    always @(posedge clk) begin
        if(reset) state <= OFF;
        else state <= next_state;
    end
endmodule