module TopModule (
    input clk,
    input reset,
    input in,
    output reg disc,
    output reg flag,
    output reg err
);

    // State encoding parameters
    parameter [2:0] 
        S_IDLE = 3'b000,  // 0 consecutive 1s
        S_1    = 3'b001,  // 1 consecutive 1
        S_2    = 3'b010,  // 2 consecutive 1s
        S_3    = 3'b011,  // 3 consecutive 1s
        S_4    = 3'b100,  // 4 consecutive 1s
        S_5    = 3'b101,  // 5 consecutive 1s
        S_6    = 3'b110,  // 6 consecutive 1s
        S_ERR  = 3'b111;  // Error state (7+ consecutive 1s)

    reg [2:0] current_state, next_state;

    // Next state logic using continuous assignment
    assign next_state = 
        reset ? S_IDLE :
        (current_state == S_IDLE) ? (in ? S_1 : S_IDLE) :
        (current_state == S_1)    ? (in ? S_2 : S_IDLE) :
        (current_state == S_2)    ? (in ? S_3 : S_IDLE) :
        (current_state == S_3)    ? (in ? S_4 : S_IDLE) :
        (current_state == S_4)    ? (in ? S_5 : S_IDLE) :
        (current_state == S_5)    ? (in ? S_6 : S_IDLE) :
        (current_state == S_6)    ? (in ? S_ERR : S_IDLE) :
        (current_state == S_ERR)  ? (in ? S_ERR : S_IDLE) :
        S_IDLE;

    // State register
    always @(posedge clk) begin
        current_state <= next_state;
    end

    // Output registers
    always @(posedge clk) begin
        if (reset) begin
            disc <= 0;
            flag <= 0;
            err <= 0;
        end else begin
            disc <= (current_state == S_5) && !in;
            flag <= (current_state == S_6) && !in;
            err <= (current_state == S_6 && in) || (current_state == S_ERR);
        end
    end

endmodule