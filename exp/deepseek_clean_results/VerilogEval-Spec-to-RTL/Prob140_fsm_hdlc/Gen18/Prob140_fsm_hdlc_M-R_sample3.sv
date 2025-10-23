module TopModule (
    input clk,
    input reset,
    input in,
    output reg disc,
    output reg flag,
    output reg err
);

    localparam [3:0] 
        IDLE = 0,
        S1   = 1,
        S2   = 2,
        S3   = 3,
        S4   = 4,
        S5   = 5,
        S6   = 6,
        ERR  = 7;

    reg [3:0] current_state, next_state;

    // State transition logic
    always @(*) begin
        case (current_state)
            IDLE: next_state = in ? S1 : IDLE;
            S1:   next_state = in ? S2 : IDLE;
            S2:   next_state = in ? S3 : IDLE;
            S3:   next_state = in ? S4 : IDLE;
            S4:   next_state = in ? S5 : IDLE;
            S5:   next_state = in ? S6 : IDLE;
            S6:   next_state = in ? ERR : IDLE;
            ERR:  next_state = in ? ERR : IDLE;
            default: next_state = IDLE;
        endcase
    end

    // Sequential logic and output generation
    always @(posedge clk) begin
        if (reset) begin
            current_state <= IDLE;
            disc <= 0;
            flag <= 0;
            err <= 0;
        end else begin
            current_state <= next_state;

            // Output logic (registered)
            disc <= (current_state == S5) && !in;
            flag <= (current_state == S6) && !in;
            err <= (current_state == ERR) || ((current_state == S6) && in);
        end
    end

endmodule