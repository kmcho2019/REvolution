module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire in,
    output reg  disc,
    output reg  flag,
    output reg  err
);

    // State encoding:
    // 0: no consecutive ones
    // 1..6: number of consecutive ones detected
    // 7: error state (7 or more ones)
    reg [2:0] state, next_state;

    // State transition (combinational)
    always @(*) begin
        case (state)
            3'd0: next_state = in ? 3'd1 : 3'd0;
            3'd1: next_state = in ? 3'd2 : 3'd0;
            3'd2: next_state = in ? 3'd3 : 3'd0;
            3'd3: next_state = in ? 3'd4 : 3'd0;
            3'd4: next_state = in ? 3'd5 : 3'd0;
            3'd5: next_state = in ? 3'd6 : 3'd0;
            3'd6: next_state = in ? 3'd7 : 3'd0;
            3'd7: next_state = in ? 3'd7 : 3'd0;
            default: next_state = 3'd0;
        endcase
    end

    // Sequential state update
    always @(posedge clk) begin
        if (reset) begin
            state <= 3'd0;
        end else begin
            state <= next_state;
        end
    end

    // Outputs (Moore, registered)
    // Outputs assert for one full cycle beginning on clock after the condition
    // disc: sequence 0111110 -> when state==5 and in==0 next cycle
    // flag: sequence 01111110 -> when state==6 and in==0 next cycle
    // err: 7+ ones: when in==1 and state==6 or 7 next cycle
    always @(posedge clk) begin
        if (reset) begin
            disc <= 1'b0;
            flag <= 1'b0;
            err  <= 1'b0;
        end else begin
            disc <= (state == 3'd5) && (in == 1'b0);
            flag <= (state == 3'd6) && (in == 1'b0);
            err  <= (in == 1'b1) && ((state == 3'd6) || (state == 3'd7));
        end
    end

endmodule