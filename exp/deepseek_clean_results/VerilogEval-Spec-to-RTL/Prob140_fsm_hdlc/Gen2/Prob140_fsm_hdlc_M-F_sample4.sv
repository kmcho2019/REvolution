module TopModule (
    input clk,
    input reset,
    input in,
    output reg disc,
    output reg flag,
    output reg err
);

    // State encoding
    localparam IDLE = 3'd0;
    localparam S1   = 3'd1;
    localparam S2   = 3'd2;
    localparam S3   = 3'd3;
    localparam S4   = 3'd4;
    localparam S5   = 3'd5;
    localparam S6   = 3'd6;
    localparam ERR  = 3'd7;

    reg [2:0] state, next_state;

    // State transition logic
    always @(*) begin
        case (state)
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

    // Output logic
    always @(*) begin
        disc = 0;
        flag = 0;
        err = 0;
        
        if (state == S5 && !in) disc = 1;
        if (state == S6 && !in) flag = 1;
        if (state == ERR) err = 1;
    end

    // State register and output registers
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            disc <= 0;
            flag <= 0;
            err <= 0;
        end else begin
            state <= next_state;
            
            // Register outputs for one cycle
            disc <= (state == S5 && !in);
            flag <= (state == S6 && !in);
            err <= (next_state == ERR);
        end
    end

endmodule