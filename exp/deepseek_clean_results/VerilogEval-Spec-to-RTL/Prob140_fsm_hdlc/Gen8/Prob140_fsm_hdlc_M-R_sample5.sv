module TopModule (
    input clk,
    input reset,
    input in,
    output reg disc,
    output reg flag,
    output reg err
);

    // State encoding
    localparam IDLE = 0;
    localparam S1   = 1;
    localparam S2   = 2;
    localparam S3   = 3;
    localparam S4   = 4;
    localparam S5   = 5;
    localparam S6   = 6;
    localparam ERR  = 7;

    reg [2:0] state, next_state;

    // State transition logic
    always @(*) begin
        case (state)
            IDLE: next_state = in ? S1 : IDLE;
            S1:   next_state = in ? S2 : IDLE;
            S2:   next_state = in ? S3 : IDLE;
            S3:   next_state = in ? S4 : IDLE;
            S4:   next_state = in ? S5 : IDLE;
            S5:   next_state = in ? S6 : (in ? S1 : IDLE);
            S6:   next_state = in ? ERR : (in ? S1 : IDLE);
            ERR:  next_state = in ? ERR : IDLE;
            default: next_state = IDLE;
        endcase
    end

    // State register and output logic
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            disc <= 0;
            flag <= 0;
            err <= 0;
        end else begin
            state <= next_state;
            
            // Default outputs
            disc <= 0;
            flag <= 0;
            err <= 0;

            // Output conditions
            case (state)
                S5: if (!in) disc <= 1;
                S6: if (!in) flag <= 1;
                ERR: err <= 1;
            endcase
        end
    end

endmodule