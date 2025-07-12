module TopModule(
    input  wire clk,
    input  wire resetn,
    input  wire x,
    input  wire y,
    output reg  f,
    output reg  g
);

    // State encoding using localparam
    localparam [2:0] 
        A              = 3'd0,
        F_PULSE        = 3'd1,
        MONITOR_X_0    = 3'd2, // expect x=1
        MONITOR_X_1    = 3'd3, // expect x=0
        MONITOR_X_2    = 3'd4, // expect x=1
        G_ON_MONITOR_Y = 3'd5,
        G_ON_PERM      = 3'd6,
        G_OFF_PERM     = 3'd7;

    reg [2:0] state, next_state;
    reg [1:0] y_count; // counts y monitoring cycles (0..2)

    // State register and y_count update
    always @(posedge clk) begin
        if (!resetn) begin
            state   <= A;
            y_count <= 2'd0;
        end else begin
            state <= next_state;
            if (state == G_ON_MONITOR_Y) begin
                if (y_count < 2'd2)
                    y_count <= y_count + 1'b1;
            end else begin
                y_count <= 2'd0;
            end
        end
    end

    // Next state logic
    always @(*) begin
        next_state = state;
        case(state)
            A: begin
                if (resetn)
                    next_state = F_PULSE;
                else
                    next_state = A;
            end
            F_PULSE: next_state = MONITOR_X_0;

            MONITOR_X_0: next_state = (x == 1'b1) ? MONITOR_X_1 : MONITOR_X_0;

            MONITOR_X_1: next_state = (x == 1'b0) ? MONITOR_X_2 :
                         (x == 1'b1) ? MONITOR_X_1 : MONITOR_X_0; // restart if x!=0 or 1

            MONITOR_X_2: next_state = (x == 1'b1) ? G_ON_MONITOR_Y : MONITOR_X_0;

            G_ON_MONITOR_Y: begin
                if (y == 1'b1)
                    next_state = G_ON_PERM;
                else if (y_count == 2'd2)
                    next_state = G_OFF_PERM;
                else
                    next_state = G_ON_MONITOR_Y;
            end

            G_ON_PERM:  next_state = G_ON_PERM;

            G_OFF_PERM: next_state = G_OFF_PERM;

            default: next_state = A;
        endcase
    end

    // Output logic (Moore FSM)
    always @(*) begin
        f = 1'b0;
        g = 1'b0;
        case(state)
            F_PULSE:       f = 1'b1;
            G_ON_MONITOR_Y,
            G_ON_PERM:     g = 1'b1;
            default:       /* f=0, g=0 */;
        endcase
    end

endmodule